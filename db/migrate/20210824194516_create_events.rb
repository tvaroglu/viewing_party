class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :movie_title
      t.date :event_date
      t.datetime :event_time
      t.integer :runtime
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
