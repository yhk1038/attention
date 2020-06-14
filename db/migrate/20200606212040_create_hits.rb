class CreateHits < ActiveRecord::Migration[6.0]
  def change
    create_table :hits do |t|
      t.string :ip_address
      t.references :notification, null: false, foreign_key: true

      t.timestamps
    end
  end
end
