###############################################################################
# TASK: write_exif
#
# given a CSV of metadata and directory,
# for each file listed in metadata, write the metadata into the corresponding file
# 
###############################################################################

desc "find all pdfs in directory, count all pages, and log errors"
task :write_exif, [:csv_file, :directory] do |_t, args|
  args.with_defaults(
    csv_file: 'metadata.csv',
    directory: 'objects'
  )

  # check for existing csv file
  unless File.exist?(args.csv_file)
    puts "The metadata CSV #{csv_file} does not exist. Please check your arguments. Exiting."
    next
  end

  # check for existing directory
  target_dir = File.expand_path(args[:directory])
  unless Dir.exist?(target_dir)
    puts "Directory not found #{target_dir}! Please check your arguments. Exiting."
    next
  end

  # read csv file
  csv_text = File.read(args.csv_file, :encoding => 'utf-8')
  csv_contents = CSV.parse(csv_text, headers: true)

  # iterate over csv rows
  csv_contents.each do |item|
    
    # check if file exists - if not, record error and skip to next

    # check file type (pdf, image, audio, video) 
    # to decide on fields and metadata method

    # get metadata values for item

    # write exif metadata to file

    # save any errors

  end

  # create a txt file for output report
  # write total files, list of errors to report

  puts "Metadata added to: #{success_count}"
  puts "Files with errors: #{error_files.size}"
  puts "Report: #{output_txt}"

end