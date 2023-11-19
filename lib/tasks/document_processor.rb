#!/usr/bin/env ruby
require_relative '../../config/environment'

DOCUMENTO_QUEUE.subscribe(block: true) do |delivery_info, properties, body|
  documento_id = body
  documento = Documento.find(documento_id)
end