class CreateHypertableOnMeasurements < ActiveRecord::Migration[7.0]
  def create
    execute "SELECT create_hypertable('measurements','created_at')"
  end
end
