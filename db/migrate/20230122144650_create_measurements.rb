class CreateMeasurements < ActiveRecord::Migration[7.0]
  def change
    create_table   :measurements, id: false do |t|
      t.references :channel, null: false, foreign_key: true
      t.text       :metric, null: false
      t.float      :value
      t.datetime   :created_at, null: false
    end
    add_index :measurements, [:channel_id, :metric, :created_at], unique: true
  end
end
