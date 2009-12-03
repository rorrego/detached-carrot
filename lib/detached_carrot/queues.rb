module DetachedCarrot
  class Queues
    include Singleton
    attr :queues, true

    def initialize(opts={})
      @queues ||= generar_listado
    end
    
    def assign_queue(opts = {})
      queue = (opts[:queue].blank?)? @queues.first : opts[:queue]
      @queues[queue][:tomado] = true
      return opts[:server].queue(queue)
    end
  end
  
  private
  
  def generar_listado
    result = {}
    CARROTS_CONFIG['queues'].each do |q|
      result << q => {:tomado => false}
    end
    return result
  end
end