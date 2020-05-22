class AddAllowRepublishAtToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :allow_republish_at, :datetime
  end
end
