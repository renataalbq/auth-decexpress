require 'bunny'

class PdfDownloadWorker
  def start
    queue = RABBITMQ_CONNECTION.create_channel.queue('request_document')
  
    queue.subscribe(block: true) do |delivery_info, properties, body|
      next if body.empty?
      message = JSON.parse(body)
      process_message(message)
    rescue JSON::ParserError => e
      puts "Erro ao analisar a mensagem: #{e.message}"
    end
  end

  def self.send_to_queue(document)
    conn = Bunny.new(automatically_recover: false)
    conn.start
  
    channel = conn.create_channel
    queue = channel.queue('request_document')
  
    begin
      queue.publish({document_id: @document.id}.to_json, routing_key: queue.name)

      puts " [x] Enviado #{document.to_json}"
    rescue StandardError => e
      puts " [!] Erro enviando mensagem: #{e.message}"
    ensure
      conn.close
    end
  end
  
    private
  
    def process_message(message)
      puts "Mensagem recebida: #{message}"
      document_id = message['document_id']
      puts "ID do Documento: #{document_id}"
      return unless document_id
      document = Document.find(document_id)
  
      pdf_path = document_pdf_path(document)
    end
  
    def document_pdf_path(document)
      Rails.root.join('public', 'pdfs', "documento_#{document.id}.pdf")   
    end
  end
