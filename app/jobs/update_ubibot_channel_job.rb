class UpdateUbibotChannelJob < ApplicationJob
  queue_as :default

  def perform(channel_id)
    if channel = Channel.find(channel_id)
      Rails.logger.info "Query channel (#{channel.id}) #{channel.name}"
      channel.update_channel
    end
  end
end
