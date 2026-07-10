class CreateWorkoutSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :workout_sessions do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
