channel = Queues::RabbitMq.consumer_channel
exchange = channel.default_exchange
queue = channel.queue("ads", durable: true)

queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  body = JSON(payload)

  params = {
    lat: body["lat"],
    lon: body["lon"],
    post_id: body["post_id"]
  }

  Container["services.posting.commands.update_coordinates"].call(params)

  exchange.publish(
    "ok",
    routing_key: properties.reply_to,
    correlation_id: properties.correlation_id
  )

  channel.ack(delivery_info.delivery_tag)
end
