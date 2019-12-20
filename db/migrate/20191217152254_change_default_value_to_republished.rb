class ChangeDefaultValueToRepublished < ActiveRecord::Migration[5.1]
  def change
    change_column_default :requests, :republised, 0
  end
end
