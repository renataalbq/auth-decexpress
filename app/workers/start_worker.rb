require_relative 'document_email_sender_worker'

worker = DocumentEmailWorker.new
worker.start