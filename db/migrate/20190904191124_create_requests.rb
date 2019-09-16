class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.string :title
      t.text :desc
      t.float :lat
      t.float :lng
      t.boolean :status

      t.timestamps
    end
  end
end
