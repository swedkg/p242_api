class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.string :title
      t.text :desc

      t.timestamps
    end
  end
end
