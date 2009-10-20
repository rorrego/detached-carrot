require 'json'
module DetachedCarrot
  class Base
    cattr_accessor :logger
    attr_accessor   :server
    attr_accessor   :queue    
    
    @@logger ||= ::RAILS_DEFAULT_LOGGER

    def initialize(options={})
      @queue = DetachedCarrot::Server.instance.queue
    end

    def listen
      while(!@shutdown) do
        pop
      end        
    end
    
    def stop   
      DetachedCarrot::Server.instance.stop   
      @shutdown = true
    end
  
    def pop
      return unless @queue.message_count > 0
      begin
        job = @queue.pop(:ack => true)
        puts "Popping: #{job.inspect}"
        job = JSON.parse(job)
        @queue.ack
        puts "job: #{job['type']}.find(#{job['id']}).#{job['task']}"
        options = []
        options << job['options'][0].key_strings_to_symbols! unless job['options'][0].nil?
        puts " the options are #{options.inspect}"
        args = [job['task']] + options # what to send to the object
        puts "passing arguments #{args.inspect}"
        if job['id']
          puts "#{job['type']}.find(#{job['id']}).#{job['task']}"          
          job['type'].constantize.find(job['id']).send(*args)
        else
          puts "#{job['type']}.#{job['task']}"          
          job['type'].constantize.send(*args)
        end
        puts "[#{Time.now.to_s(:db)}] Popped #{job['task']} on #{job['type']} #{job['id']}"
      rescue ActiveRecord::RecordNotFound
        if job['tries'].blank?
          job['tries'] = 0
        end
        unless job['tries'] > 10
          job['tries'] = job['tries'] + 1
          @queue.publish(job.to_json)        
        end
        puts "[#{Time.now.to_s(:db)}] WARNING #{job['type']}##{job['id']} gone from database. Tries: #{job['tries']}"
      rescue ActiveRecord::StatementInvalid
        puts "[#{Time.now.to_s(:db)}] WARNING Database connection gone, reconnecting & retrying."
        @queue.publish(job.to_json)
        ActiveRecord::Base.connection.reconnect!
        retry
      rescue Exception => error
        puts "[#{Time.now.to_s(:db)}] ERROR #{error.message}"        
      end
    end


    def stats
      puts "Queued #{self.message_count} messages"
    end
    
    
    def message_count
     return @server.message_count
    end

    def feedback(message)
      puts "=> [D-CARROT] #{message}"
    end

  end  
end
