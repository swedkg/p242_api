class RomoveTimestampFromMessages < ActiveRecord::Migration[5.2]
  def change
    remove_column :messages, :timestamp
  end
end
