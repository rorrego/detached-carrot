puts '=> Loading Rails...'

require File.dirname(__FILE__) + '/../../../../config/environment'

invoker = DetachedCarrot::Base
poller = invoker.new(:queue => nil)
puts '** Rails loaded.'
puts "** Starting #{invoker} for the queue '#{queue}'"
puts '** Use CTRL-C to stop.'

ActiveRecord::Base.logger = DetachedCarrot::Base.logger
ActionController::Base.logger = DetachedCarrot::Base.logger

trap(:INT) { poller.stop; exit }

begin
  poller.listen
ensure
  puts '** No Pollers found.'
  puts "** Exiting at #{Time.now}"
end

def tail(log_file)
  cursor = File.size(log_file)
  last_checked = Time.now
  tail_thread = Thread.new do
    File.open(log_file, 'r') do |f|
      loop do
        f.seek cursor
        if f.mtime > last_checked
          last_checked = f.mtime
          contents = f.read
          cursor += contents.length
          print contents
        end
        sleep 1
      end
    end
  end
  tail_thread
end