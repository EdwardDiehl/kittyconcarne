class CreateUserEvents < ActiveRecord::Migration
  def change
    create_table :user_events do |t|
      t.string :uuid
      t.references :event, index: true, foreign_key: true
      t.string :status

      t.timestamps null: false
    end
  end
end
