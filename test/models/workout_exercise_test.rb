require "test_helper"

class WorkoutExerciseTest < ActiveSupport::TestCase
  test "assigns the next position within its workout session automatically" do
    workout_exercise = workout_sessions(:one).workout_exercises.create!(exercise: exercises(:two))
    assert_equal workout_exercises(:one).position + 1, workout_exercise.position
  end

  test "cannot add the same exercise twice to a workout session" do
    workout_exercise = workout_sessions(:one).workout_exercises.build(exercise: workout_exercises(:one).exercise)
    assert_not workout_exercise.valid?
  end

  test "summary reports no sets yet when empty" do
    workout_exercise = workout_sessions(:one).workout_exercises.create!(exercise: exercises(:two))
    assert_equal "No sets yet", workout_exercise.summary
  end

  test "summary lists each set's weight and reps in order" do
    workout_exercise = workout_sessions(:one).workout_exercises.create!(exercise: exercises(:two))
    workout_exercise.set_entries.create!(weight: 60, reps: 6)
    workout_exercise.set_entries.create!(weight: 55.5, reps: 6)

    assert_equal "2 sets: 60x6 - 55.5x6", workout_exercise.reload.summary
  end
end
