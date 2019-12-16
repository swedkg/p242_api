class ChangeStatusToBoolInFullfilments < ActiveRecord::Migration[5.1]
  def change
    change_column :fullfilments, :status, 'boolean USING CAST(status AS boolean)'
  end
end
