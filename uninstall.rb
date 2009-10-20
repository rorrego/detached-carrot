# Uninstall hook code here
require 'fileutils'

dir = Dir.getwd
archivos = {
    :carrot_config => "#{dir}/config/carrots.yml",
    :carrot_initializer => "#{dir}/config/carrots.yml",
    :carrot_script => "#{dir}/config/carrots.yml"
}

archivos.each_pair {|key, value|
  FileUtils.rm(value)
  puts "Borrado #{key}"    
    }

puts "Ahora rm -rf vendor/plugins/detached-carrot"