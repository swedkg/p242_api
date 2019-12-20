class AddFulfilledToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :fulfilled, :boolean, default: false
  end
end
