class AddPositionToExercises < ActiveRecord::Migration[8.1]
  def up
    add_column :exercises, :position, :integer

    Exercise.order(:name).each_with_index do |exercise, index|
      exercise.update_column(:position, index + 1)
    end

    change_column_null :exercises, :position, false
  end

  def down
    remove_column :exercises, :position
  end
end
