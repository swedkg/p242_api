class AddRepublishedToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :republised, :integer
  end
end
