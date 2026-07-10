class AddDefaultSelectedToExercises < ActiveRecord::Migration[8.1]
  def change
    add_column :exercises, :default_selected, :boolean, default: false, null: false
  end
end
