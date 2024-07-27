###############################################################################
# TASK: build_offline
#
# build a CollectionBuilder site and replace links for offline use
#
# replacement for https://github.com/dohliam/jekyll-offline
# with CollectionBuilder specific considerations
#
###############################################################################

# function to process html files and replace links
def process_html(html_file, depth) 

  puts "processing #{html_file}, depth #{depth}"
  # open file in write
  # find and replace links

end

# function to process _site directory and sub directories to one depth
def process_directory(site_directory)

  # get list of all files
  Dir.glob(File.join(site_directory, "*")).each do |filename|
    
    # extensions to process
    process_extensions = [ '.html', '.js' ]

    # subdirectories
    if File.directory?(filename) 
      # subdir depth for link replace
      puts "sub dir"
      Dir.glob(File.join(filename, "*")).each do |subfilename|
        if !File.directory?(subfilename) 
          extname = File.extname(subfilename).downcase
          if process_extensions.include?(extname)
            # process files
            process_html(subfilename, "1")
            next
          end
        end
      end

      next
    end

    # first level files
    extname = File.extname(filename).downcase
    if process_extensions.include?(extname)
      # process files
      process_html(filename, "0")
      next
    end

    puts "skipping unnecessary file"
    
  end

end

desc 'Build jekyll site and replace links for offline use'
task :build_offline do
  
  # build jekyll site
  #ENV['JEKYLL_ENV'] = 'production'
  #system('bundle', 'exec', 'jekyll', 'build')
  
  # make copy of built out site
  # create new directory for offline site
  jekyll_site = '_site'
  offline_dir = 'offline_site'
  FileUtils.mkdir_p(offline_dir) unless Dir.exist?(offline_dir)
  # copy built site to new directory
  FileUtils.cp_r(jekyll_site, offline_dir)
  # process copy
  process_directory(File.join(offline_dir, jekyll_site))

end

