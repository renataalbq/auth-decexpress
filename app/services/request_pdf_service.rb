require 'bunny'

class RequestPdfService
  def initialize
    @connection = Bunny.new(automatically_recover: false)
    @connection.start
  end

  def channel
    @channel ||= @connection.create_channel
  end

  def queue
    @queue ||= channel.queue('pdf_requests')
  end

  def publish(document_id)
    message = { document_id: document_id }.to_json
    channel.default_exchange.publish(message, routing_key: queue.name)
  end

  def close
    @connection.close
  end
end
