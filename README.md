# rake-utilities-for-digital

A repository of helpful Rake tasks to automate bulk processes commonly used to prep objects for digital collections. 

## Overview

Rake is a automation tool written in Ruby. 
It is a standard part of all Ruby installs, so if you have Ruby, it is installed!
(Although, you may need to `bundle install` to get all the Gems.)

Each task is documented in the "docs/" folder in a markdown file matching the task's name. 
The documentation provides information about how to use the task, requirements, options, and example commands.

Each task itself is an individual `.rake` file in the "rakelib/" directory, that contains basic ruby scripts. 

The general workflow is to temporarily copy CSVs and folders of object files into this repository folder to work on using the Rake tasks, then copy the outputs to where ever they need to go. 
Don't commit the inputs and outputs into this repository, as it is just for maintaining the Rake tasks!

*Note:* many of these are fairly idiosyncratic task, but are simple with lots of comments, so can be modified for a variety of purposes!

Created with Ruby 3.2.x+.

## Using Rake Tasks

To use a Rake task you will open your terminal in the root of this repository. 
The commands follow the pattern: `rake task_name`.

Tasks can be given "arguments" to pass options to the command. 
Arguments follow the pattern: `rake task_name["arg1","arg2","arg3"]`.

Arguments are surrounded by square brackets `[` and `]`.
Each argument must be surrounded by double quotes `"`, separated by comma `,`, with no spaces between. 

To use all the default options, do not add arguments to the task, e.g. `rake resize_images`.
To use the default option for some arguments, leave the place blank with no space, e.g. `rake resize_images["300x300",,,"output_folder"]` (the second and third argument will be the default).
