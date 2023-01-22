require "test_helper"

class ChannelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @channel = channels(:one)
  end

  test "should get index" do
    get channels_url
    assert_response :success
  end

  test "should get new" do
    get new_channel_url
    assert_response :success
  end

  test "should create channel" do
    assert_difference("Channel.count") do
      post channels_url, params: { channel: { device_id: @channel.device_id, last_entry_timestamp: @channel.last_entry_timestamp, location: @channel.location, name: @channel.name, product_id: @channel.product_id, sensor_type: @channel.sensor_type } }
    end

    assert_redirected_to channel_url(Channel.last)
  end

  test "should show channel" do
    get channel_url(@channel)
    assert_response :success
  end

  test "should get edit" do
    get edit_channel_url(@channel)
    assert_response :success
  end

  test "should update channel" do
    patch channel_url(@channel), params: { channel: { device_id: @channel.device_id, last_entry_timestamp: @channel.last_entry_timestamp, location: @channel.location, name: @channel.name, product_id: @channel.product_id, sensor_type: @channel.sensor_type } }
    assert_redirected_to channel_url(@channel)
  end

  test "should destroy channel" do
    assert_difference("Channel.count", -1) do
      delete channel_url(@channel)
    end

    assert_redirected_to channels_url
  end
end
