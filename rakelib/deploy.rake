###############################################################################
# TASK: deploy
#
# build a jekyll site in the 'production' environment
###############################################################################

desc 'Build site with production env'
task :deploy do
  ENV['JEKYLL_ENV'] = 'production'
  system('bundle', 'exec', 'jekyll', 'build')
end

