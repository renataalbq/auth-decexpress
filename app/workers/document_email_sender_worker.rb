require 'bunny'

class DocumentEmailWorker
  def initialize
    @connection = Bunny.new
    @connection.start
    @channel = @connection.create_channel
    @queue = @channel.queue('documents')
  end

  private
  
  def start
    @queue.subscribe(block: true) do |delivery_info, properties, body|
      process_document(body)
    end
  end

  private

  def process_document(document_id)
    document = Document.find(document_id)
    pdf_path = Rails.root.join('public', 'pdfs', "documento_#{document_id}.pdf")
    send_email(document, pdf_path)
  end

  def send_email(document, pdf_path)
    DocumentMailer.send_document(document, pdf_path).deliver_now
  end
end
worker = DocumentEmailWorker.new
worker.start