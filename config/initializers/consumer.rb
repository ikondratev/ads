channel = Queues::RabbitMq.consumer_channel
exchange = channel.default_exchange
queue = channel.queue("geocoding", durable: true)

queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  payload = JSON(payload)
  user_id = payload["user_id"]

  exchange.publish(
    "ok",
    routing_key: properties.reply_to,
    correlation_id: properties.correlation_id
  )

  channel.ack(delivery_info.delivery_tag)
end