###############################################################################
# TASK: count_pdf_pages
#
# given a directory, finds all pdf files
# outputs a count of pdfs, a count of total pdf pages, and list of any filenames with errors
#
###############################################################################

desc "find all pdfs in directory, count all pages, and log errors"
task :count_pdf_pages, [:directory, :recursive, :output_csv] do |_t, args|
  args.with_defaults(
    directory: '.',
    recursive: 'true',
    output_csv: 'pdf_count.csv'
  )

  # check for existing csv file
  if File.exist?(args.output_csv)
    puts "Output CSV already exists! Please change output name. Exiting."
    next
  end

  # check for existing directory
  target_dir = File.expand_path(args[:directory])
  unless Dir.exist?(target_dir)
    puts "Directory not found #{target_dir}! Please check your arguments. Exiting."
    next
  end

  recursive = args[:recursive].to_s.strip.downcase != 'false'
  output_csv = File.expand_path(args[:output_csv])
  FileUtils.mkdir_p(File.dirname(output_csv))

  pdf_reader_available = begin
    require 'pdf-reader'
    true
  rescue LoadError
    false
  end

  pdf_page_count = lambda do |path|
    errors = []

    if pdf_reader_available
      begin
        return PDF::Reader.new(path).page_count
      rescue StandardError => e
        errors << "pdf-reader: #{e.message}"
      end
    end

    begin
      stdout, stderr, status = Open3.capture3('pdfinfo', path)
      raise stderr.strip unless status.success?
      pages_line = stdout.each_line.find { |line| line.start_with?('Pages:') }
      raise 'pdfinfo output missing "Pages:" line' unless pages_line
      return pages_line.split(':', 2).last.strip.to_i
    rescue Errno::ENOENT
      errors << 'pdfinfo command not found'
    rescue StandardError => e
      errors << "pdfinfo: #{e.message}"
    end

    raise errors.join(' | ')
  end

  glob_pattern = recursive ? File.join(target_dir, '**', '*.pdf') : File.join(target_dir, '*.pdf')
  pdf_files = Dir.glob(glob_pattern, File::FNM_CASEFOLD).select { |path| File.file?(path) }.sort

  total_pages = 0
  error_files = []

  pdf_files.each do |file|
    begin
      total_pages += pdf_page_count.call(file)
    rescue StandardError => e
      error_files << { file:, message: e.message }
    end
  end

  CSV.open(output_csv, 'w', write_headers: true, headers: %w[name count error_message]) do |csv|
    csv << ['Total PDF files', pdf_files.size, nil]
    csv << ['Total PDF pages', total_pages, nil]
    csv << ['Files with errors', error_files.size, nil]

    error_files.each do |err|
      csv << [err[:file], nil, err[:message]]
    end
  end

  puts "Total PDF files: #{pdf_files.size}"
  puts "Total PDF pages: #{total_pages}"
  puts "Files with errors: #{error_files.size}"
  puts "Wrote CSV: #{output_csv}"
end