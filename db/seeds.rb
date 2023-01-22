# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

ubibot_channels_file_path = ENV.fetch("UBIBOT_CHANNELS_FILE_PATH") { "db/data/ubibot_channels.yaml" }
puts ubibot_channels_file_path

YAML.load(File.read(ubibot_channels_file_path))["ubibot_channels"].each do |key, value|
  channel = Channel.find_or_create_by(id: key.to_i)
  channel.name        = value["name"]
  channel.sensor_type = value["sensor_type"]
  channel.location    = value["location"] if value["location"]
  channel.tag_list    = value["tags"].join(",") if value["tags"]
  channel.save
end
