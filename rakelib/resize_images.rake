###############################################################################
# TASK: resize_images
#
# create smaller images for image files in the 'objects' folder
###############################################################################

require 'mini_magick'

def process_image(filename, output_filename, size)
  puts "Creating: #{output_filename}"
    begin
      MiniMagick.convert do |convert|
        convert << filename
        convert.resize(size)
        convert.flatten
        convert << output_filename
      end
    rescue StandardError => e
      puts "Error creating #{filename}: #{e.message}"
    end
  end
end


desc 'Resize image files from folder'
task :generate_derivatives, [:new_size, :input_dir, :output_dir] do |_t, args|
  # set default arguments
  args.with_defaults(
    new_size: '5000x5000',
    input_dir: 'objects',
    output_dir: 'resized'
  )

  # set the folder locations
  objects_dir = args.input_dir
  output_dir = args.output_dir
  new_size = args.new_size

  # ensure input directory exists
  if !Dir.exist?(objects_dir)
    puts "Input folder does not exist! resize_images not run."
    break
  end

  # ensure output directory exists
  FileUtils.mkdir_p(output_dir) unless Dir.exist?(output_dir)
  
  # support these file types
  EXTNAME_TYPE_MAP = {
    '.jpeg' => :image,
    '.jpg' => :image,
    '.png' => :image,
    '.tif' => :image,
    '.tiff' => :image
  }.freeze

  # Iterate over all files in the objects directory.
  Dir.glob(File.join(objects_dir, '*')).each do |filename|
    # Skip subdirectories 
    if File.directory?(filename)
      next
    end

    # Determine the file type and skip if unsupported.
    extname = File.extname(filename).downcase
    file_type = EXTNAME_TYPE_MAP[extname]
    unless file_type
      puts "Skipping file with unsupported extension: #{filename}"
      next
    end

    # Get the lowercase filename without any leading path and extension.
    base_filename = File.basename(filename, '.*').downcase

    # Create new filename
    new_filename = File.join(output_dir, "#{base_filename}.#{extname}")

    # check if file already exists
    if File.exist?(new_filename)
      puts "new filename '#{new_filename}' already exists, skipping!"
      next
    else 
      # resize
      process_image(filename, new_filename, new_size)
    end
    
  end
  
  puts "\e[32mImages resized to '#{output_dir}.\e[0m"
end
