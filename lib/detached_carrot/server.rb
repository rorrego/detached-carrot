require 'singleton'
module DetachedCarrot
  class Server
    include Singleton

    attr_reader :server, :queue
    
    def initialize()
      @server ||= Carrot.new(:host => CARROTS_CONFIG['host'], :port => CARROTS_CONFIG['port'])
      @queue ||= @server.queue(CARROTS_CONFIG['queue'])
      
    end
    
    def close
      @server.stop
    end

  end
  
end