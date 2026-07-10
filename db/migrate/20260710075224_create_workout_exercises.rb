class CreateWorkoutExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :workout_exercises do |t|
      t.references :workout_session, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :position, null: false

      t.timestamps
    end
    add_index :workout_exercises, [ :workout_session_id, :exercise_id ], unique: true
  end
end
