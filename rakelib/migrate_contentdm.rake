###############################################################################
# TASK: migrate_contentdm
#
# read csv, download using wget, generate derivatives, create new metadata fields
#
# expects a CSV that has required columns "objectid" and "cdmid" and "format", plus optional "collectionid"
#
###############################################################################

desc "migrate contentdm collection csv"
task :migrate_contentdm, [:csv_file,:cdm_collection_id,:output_name] do |_t, args|
  # set default arguments
  args.with_defaults(
    csv_file: 'download.csv',
    cdm_collection_id: 'hwhi',
    output_name: 'new'
  )
  # set some constants
  cdm_url = 'https://digital.lib.uidaho.edu'
  output_dir = output_name + "/"

  # check for csv file
  if !File.exist?(args.csv_file)
    puts "CSV file does not exist! No files downloaded and exiting."
  else
    # read csv file
    csv_text = File.read(args.csv_file, :encoding => 'utf-8')
    csv_contents = CSV.parse(csv_text, headers: true)

    # Ensure that the output directory exists.
    FileUtils.mkdir_p(args.output_dir) unless Dir.exist?(args.output_dir)    
        
    # iterate on csv rows
    csv_contents.each_with_index do | item, index |
      # check for required fields 
      unless item[cdmid] && item[objectid] && item[format]
        puts "Skipping Row #{index} -- missing required fields (cdmid, objectid, or format)."
        next
      else
        # figure out format and extension
        item_format = 
        item_extension = 
        base_name = item[objectid] + item_extension
        # figure out download name
        name_new = File.join(args.output_dir, base_name)
        # check if file already exists
        if File.exist?(name_new)
            puts "Skipping Row #{index} -- new filename '#{name_new}' already exists."
            next
        end
        




        # check for rename
        if item[args.download_rename]
          # check if file already exists
          name_new = File.join(args.output_dir, item[args.download_rename])
          if File.exist?(name_new)
            puts "new filename '#{name_new}' already exists, skipping!"
            next
          end
          puts "downloading"
          # call wget
          system('wget','-O', name_new, item[args.download_link])
        else
          puts "downloading"
          # call wget 
          system('wget', item[args.download_link], "-P", args.output_dir)
        end
      else
        puts "no download url!"
      end
    end

    puts "done downloading."

  end

end
