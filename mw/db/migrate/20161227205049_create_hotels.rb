class CreateHotels < ActiveRecord::Migration[5.0]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :pid
      t.timestamps
    end

    add_index :hotels, :pid
  end
end
