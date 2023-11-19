require 'bunny'

RABBITMQ_CONNECTION = Bunny.new(hostname: 'localhost')
RABBITMQ_CONNECTION.start

RABBITMQ_CHANNEL = RABBITMQ_CONNECTION.create_channel

DOCUMENTO_QUEUE = RABBITMQ_CHANNEL.queue('documentos')