class CreateSetEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :set_entries do |t|
      t.references :workout_exercise, null: false, foreign_key: true
      t.integer :set_number, null: false
      t.decimal :weight, precision: 6, scale: 2, null: false
      t.integer :reps, null: false

      t.timestamps
    end
  end
end
