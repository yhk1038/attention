class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :full_name
      t.string :slug

      t.timestamps
    end
  end
end
