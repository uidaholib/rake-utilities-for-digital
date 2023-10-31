# rake-utilities-for-digital

A repository of Rake tasks to help common processes in digital, including prepping objects for digital collections. 

Each task has an individual `.rake` file in the "rakelib/" directory and is documented in the "docs/" folder following the task's name.

Rake is a automation tool written in Ruby. 
It is a standard part of all Ruby installs, so if you are using Jekyll, you have it installed already.

The general workflow is to temporarily copy CSVs and folders of object files into this repository folder to work on using the Rake tasks, then copy the outputs to where ever they need to go. 
Don't commit the inputs and outputs into this repository, as it is just for maintaining the Rake tasks!
