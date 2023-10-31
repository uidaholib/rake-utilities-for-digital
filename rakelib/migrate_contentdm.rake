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
  output_csv_name = 'migrated.csv'

  # check for csv file
  if !File.exist?(args.csv_file)
    puts "CSV file does not exist! No files downloaded and exiting."
  else
    # read csv file
    csv_text = File.read(args.csv_file, :encoding => 'utf-8')
    csv_contents = CSV.parse(csv_text, headers: true)

    # Ensure that the output directory exists.
    FileUtils.mkdir_p(args.output_dir) unless Dir.exist?(args.output_dir)
    
    # setup output data array
    output_csv = []
    existing_fields = csv_contents.headers
    # add rows
    new_fields = 'display_template,filename,object_location,image_small,image_thumb,errors'.split(',')
    existing_fields.push(new_fields)
    # add out output array
    output_csv.push(existing_fields)
        
    # iterate on csv rows
    csv_contents.each_with_index do | item, index |
      # check for required fields 
      if !item['objectid']

        puts "Skipping Row #{index} -- missing required objectid."
        # add to output array with error
        add_fields = [ '', '', '', '', '', 'item missing objectid' ]
        item.push(add_fields)
        # add out output array
        output_csv.push(item)
        # skip, done
        next

      # youtube items
      elsif item['youtubeid']
        # create display_template, image_small, image_thumb
        item_display_template = "video"
        item_filename = ""
        item_object_location = "https://youtu.be/" + item['youtubeid']
        item_image_small = 'https://img.youtube.com/vi/' + item['youtubeid'] + '/hqdefault.jpg'
        item_image_thumb = 'https://img.youtube.com/vi/' + item['youtubeid'] + '/hqdefault.jpg'
        item_errors = ""
        add_fields = [ item_display_template, item_filename, item_object_location, item_image_small, item_image_thumb, item_errors ]
        item.push(add_fields)
        # add out output array
        output_csv.push(item)
        # done
        next

      # cdm items 
      elsif item['format'] && item['cdmid']
        # figure out format and extension
        item_format = item['format']
        if item_format == "image/jpeg"
          item_extension = ".jpg"
        elsif item_format == "application/pdf"
          item_extension = ".pdf"
        elsif item_format == "audio/mp3"
          item_extension = ".mp3"
        elsif item_format == "video/mp4"
          item_extension = ".mp4"
        else
          puts "Skipping Row #{index} -- unsupported format value."
          next
        end
        base_name = item[objectid] + item_extension
        # figure out download name
        name_new = File.join(args.output_dir, base_name)
        # check if file already exists
        if File.exist?(name_new)
            puts "Skipping Row #{index} -- new filename '#{name_new}' already exists."
            next
        end
        # download and rename

        
      else 
        
        puts "Skipping Row #{index} -- missing required fields cdmid or format)."
        # add to output array with error
        add_fields = [ '', '', '', '', '', 'item missing cdmid or format' ]
        item.push(add_fields)
        # add out output array
        output_csv.push(item)
        # skip, done
        next

      end
    end

    # write output csv
    CSV.open(output_csv_name, 'w') do |csv|
      csv << output_csv
    end

  end

end
