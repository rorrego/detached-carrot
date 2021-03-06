require 'erb'
require 'fileutils'

carrot_config = Dir.getwd + "/config/carrots.yml"
carrot_config_template = Dir.getwd + "/vendor/plugins/detached-carrot/files/carrots.yml.erb"

unless File.exist?(carrot_config)

  pwd = Dir.getwd
  template = File.read(carrot_config_template)
  result = ERB.new(template).result(binding)

  carrot_config_file = File.open(carrot_config, 'w+')
  carrot_config_file.puts result
  carrot_config_file.close

  puts "=> Copied carrot configuration file."

else

  puts "=> carrot configuration file already exists."

end

carrot_initializer = Dir.getwd + "/config/initializers/carrot.rb"
carrot_initializer_template = Dir.getwd + "/vendor/plugins/detached-carrot/files/carrot.rb"

unless File.exist?(carrot_initializer)

  pwd = Dir.getwd
  carrot_initializer_file = FileUtils.cp(carrot_initializer_template, carrot_initializer)
  puts "=> Copied carrot initializer file."
else
  puts "=> Carrot initializer file already exists."
end

carrot_script = Dir.getwd + "/script/detached_carrot"
carrot_script_template = Dir.getwd + "/vendor/plugins/detached-carrot/files/detached_carrot"

unless File.exist?(carrot_script)


  FileUtils.cp(carrot_script_template, carrot_script)
  FileUtils.chmod 0755, carrot_script
  puts "=> Copied carrot script file."
else
  puts "=> Carrot script file already exists."
end

