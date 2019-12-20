class RenameRepublisedInRequests < ActiveRecord::Migration[5.1]
  def change
    rename_column :requests, :republised, :republished
  end
end
