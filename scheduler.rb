#!clockwork
# clockwork scheduler.rb
require "clockwork"
include Clockwork
require File.expand_path('../config/environment',  __FILE__)

handler do |job|
  case job
  when 'update_sp1'
    Channel.where(sensor_type: "WS1").each do |channel|
      UpdateUbibotChannelJob.perform_later channel.id
    end
  when 'update_ws1'
    Channel.where(sensor_type: "SP1").each do |channel|
      UpdateUbibotChannelJob.perform_later channel.id
    end
  else
    STDERR.puts('Error: Unknown scheduler job.')
  end
end

every(1.minute,  'update_sp1')
every(5.minutes,  'update_ws1')
