class Kafka::OrderProducer
  def self.send_order_created(order)
    Karafka.producer.produce_sync(
      topic: 'orders',
      payload: {
        event: 'order_created',
        order_id: order.id,
        user_id: order.user_id,
        status: order.status,
        total: order.total,
        created_at: order.created_at
      }.to_json
    )
  end
end
