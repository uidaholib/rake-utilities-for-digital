require 'mini_magick'
require 'set'

###############################################################################
# TASK: extract_image_meta
#
# given a directory, find all image files and read embedded metadata
# outputs a spreadsheet of filenames with extracted metadata fields
#
###############################################################################

desc "find all images in directory, extract embedded metadata, and output to CSV"
task :extract_image_meta, [:directory, :recursive, :thumbs, :output_csv] do |_t, args|
  args.with_defaults(
    directory: '.',
    recursive: 'true',
    thumbs: 'false',
    output_csv: 'image_meta.csv'
  )

  recursive = args[:recursive].to_s.strip.downcase != 'false'
  thumbs_enabled = args[:thumbs].to_s.strip.downcase == 'true'

  # check for input directory
  target_dir = File.expand_path(args[:directory])
  unless Dir.exist?(target_dir)
    puts "Directory not found #{target_dir}! Please check your arguments. Exiting."
    next
  end

  # check for output csv already existing
  output_csv = File.expand_path(args[:output_csv])
  if File.exist?(output_csv)
    puts "Output CSV already exists! Please change output name. Exiting."
    next
  end

  FileUtils.mkdir_p(File.dirname(output_csv))

  # set up directory for thumbs
  thumb_dir = nil
  if thumbs_enabled
    thumb_dir = File.join(File.dirname(output_csv), 'thumbs')
    FileUtils.mkdir_p(thumb_dir)
  end

  # set up supported image extensions to process
  supported_extensions = %w[.jpeg .jpg .png .tif .tiff .dng .psd]

  # find supported image files
  glob_pattern = recursive ? File.join(target_dir, '**', '*') : File.join(target_dir, '*')
  image_files = Dir.glob(glob_pattern, File::FNM_CASEFOLD).select do |path|
    File.file?(path) && supported_extensions.include?(File.extname(path).downcase)
  end.sort

  if image_files.empty?
    puts "No supported image files found in #{target_dir}"
  end

  metadata_extractor = lambda do |image|
    metadata = {}

    identify_output = MiniMagick.identify do |identify|
      identify.format '%[EXIF:*]\n%[IPTC:*]\n%[XMP:*]\n'
      identify << image.path
    end

    identify_output.split("\n").each do |line|
      next if line.strip.empty? || !line.include?('=')
      key, value = line.split('=', 2)
      metadata[key] = value
    end

    metadata
  end

  records = []
  all_metadata_keys = Set.new

  image_files.each do |file|
    record = { name: file, metadata: {}, error: nil, thumbnail: nil }
    image = nil

    begin
      image = MiniMagick::Image.open(file)
      metadata = metadata_extractor.call(image)
      record[:metadata] = metadata
      all_metadata_keys.merge(metadata.keys)

      if thumbs_enabled
        rel_path = file.sub(/^#{Regexp.escape(target_dir)}\/?/, '')
        sanitized = rel_path.empty? ? File.basename(file) : rel_path
        thumb_basename = "#{sanitized.gsub(File::SEPARATOR, '__')}_thumb.jpg"
        thumb_path = File.join(thumb_dir, thumb_basename)

        thumb_image = image.clone
        thumb_image.auto_orient
        thumb_image.resize '400x400>'
        thumb_image.format 'jpg'
        thumb_image.write(thumb_path)
        thumb_image.destroy!

        record[:thumbnail] = thumb_path
      end
    rescue StandardError => e
      record[:error] = e.message
    ensure
      image.destroy! if image
    end

    records << record
  end

  metadata_headers = all_metadata_keys.to_a.sort
  headers = ['name'] + metadata_headers
  headers << 'thumbnail' if thumbs_enabled
  headers << 'error_message'

  CSV.open(output_csv, 'w', write_headers: true, headers: headers) do |csv|
    records.each do |record|
      row = [record[:name]]
      metadata_headers.each { |key| row << record[:metadata][key] }
      row << record[:thumbnail] if thumbs_enabled
      row << record[:error]
      csv << row
    end
  end

  puts "Processed #{records.size} image(s)"
  puts "Wrote CSV: #{output_csv}"
  puts "Thumbnails directory: #{thumb_dir}" if thumbs_enabled
end