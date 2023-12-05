require 'bunny'

class PdfDownloadWorker
    def start
      queue = RABBITMQ_CONNECTION.create_channel.queue('pdf_requests')
  
      queue.subscribe(block: true) do |delivery_info, properties, body|
        message = JSON.parse(body)
        process_message(message)
      end
    end
  
    private
  
    def process_message(message)
      document_id = message['document_id']
      document = Document.find(document_id)
  
      pdf_path = document_pdf_path(document)
    end
  
    def document_pdf_path(document)
      Rails.root.join('public', 'pdfs', "documento_#{document.id}.pdf")   
    end
  end
  