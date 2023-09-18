# frozen_string_literal: true

###############################################################################
# CollectionBuilder related helpers
#
# See "rakelib" for all rake tasks!
###############################################################################

require 'csv'
require 'fileutils'

###############################################################################
# Helper Functions
###############################################################################

def prompt_user_for_confirmation(message)
  response = nil
  loop do
    print "#{message} (Y/n): "
    $stdout.flush
    response = case $stdin.gets.chomp.downcase
               when '', 'y' then true
               when 'n' then false
               end
    break unless response.nil?

    puts 'Please enter "y" or "n"'
  end
  response
end
