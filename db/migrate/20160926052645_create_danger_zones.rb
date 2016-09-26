class CreateDangerZones < ActiveRecord::Migration
  def change
    create_table :danger_zones do |t|
      t.float :latitude
      t.float :longitude
      t.float :weight

      t.timestamps null: false
    end
  end
end
