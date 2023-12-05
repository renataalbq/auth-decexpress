require 'bunny'

RABBITMQ_CONNECTION = Bunny.new(hostname: 'localhost')
RABBITMQ_CONNECTION.start

RABBITMQ_CHANNEL = RABBITMQ_CONNECTION.create_channel

PDF_REQUESTS_QUEUE = RABBITMQ_CHANNEL.queue('pdf_requests')