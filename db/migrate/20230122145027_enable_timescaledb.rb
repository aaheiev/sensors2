class EnableTimescaledb < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'timescaledb'
  end
end
