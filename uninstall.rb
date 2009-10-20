# Uninstall hook code here
require 'fileutils'

carrot_config = Dir.getwd + "/config/carrots.yml"
FileUtils.rm(carrot_initializer)
puts "Borrado #{carrot_config}"
carrot_initializer = Dir.getwd + "/config/initializers/carrot.rb"
FileUtils.rm(carrot_initializer)
puts "Borrado #{carrot_initializer}"
puts "Ahora rm -rf vendor/plugins/detached-carrot"