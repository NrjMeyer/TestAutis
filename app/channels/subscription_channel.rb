class SubscriptionChannel < ApplicationCable::Channel
  def subscribed
    # template = 'user_%s'
    # channel = template % [current_user.id]
    # stream_from channel
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def test(data)
    template = 'user_%s'
    channel = template % [data["id"]]
    stream_from channel


    ActionCable.server.broadcast(channel, received: data["nb"])
  end
end
