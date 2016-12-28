class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.string   :guest_name
      t.integer  :preference
      t.date     :checkin_date
      t.date     :checkout_date
      t.integer  :user_id
      t.integer  :hotel_id
      t.timestamps
    end

    add_index :bookings, :user_id
    add_index :bookings, :hotel_id
  end
end
