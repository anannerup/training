class AddUsesBarbellToExercises < ActiveRecord::Migration[8.1]
  def change
    add_column :exercises, :uses_barbell, :boolean, default: false, null: false
  end
end
