class AddOrganizationIdToProject < ActiveRecord::Migration[6.0]
  def change
    add_reference :projects, :organization, foreign_key: true
  end
end
