# Uninstall hook code here
require 'fileutils'

dir = Dir.getwd
archivos = {
    :carrot_config => "#{dir}/config/carrots.yml",
    :carrot_initializer => "#{dir}/config/initializers/carrot.rb",
    :carrot_script => "#{dir}/script/detached_carrot"
}

archivos.each_pair {|key, value|
  begin
    FileUtils.rm(value)
    puts "Borrado #{key}"    
  rescue => e
    puts "No se pudo Borrar #{key} por #{e.message}"        

  end
    }

puts "Ahora rm -rf vendor/plugins/detached-carrot"