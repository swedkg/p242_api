class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.timestamp :timestamp
      t.text :message
      t.references :fullfilment, foreign_key: true
      t.references :sender, foreign_key: {to_table: :users}, index: true
      t.references :receiver, foreign_key: {to_table: :users}, index: true

      t.timestamps
    end
  end
end
