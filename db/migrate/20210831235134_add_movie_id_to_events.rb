class AddMovieIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :movie_id, :integer
  end
end
