require 'singleton'
module DetachedCarrot
  class Server
    include Singleton

    attr_reader :server, :queue
    
    def initialize(opts={})
      @server ||= Carrot.new(:host => CARROTS_CONFIG['host'], :port => CARROTS_CONFIG['port'])
      @queue  ||= DetachedCarrot::Queues.instance.assign_queue(:server => @server, :queue => opts[:queue])
    end
    
    def close
      @server.stop
    end

  end
  
end