class AddAddressToRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :address, :string
  end
end
