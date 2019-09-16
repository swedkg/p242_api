class AddOnwerToRequest < ActiveRecord::Migration[5.1]
  def change
    add_reference :requests, :owner, foreign_key: {to_table: :users}
  end
end
