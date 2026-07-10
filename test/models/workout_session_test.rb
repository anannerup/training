require "test_helper"

class WorkoutSessionTest < ActiveSupport::TestCase
  test "orders workout exercises by position" do
    workout_session = workout_sessions(:one)
    later = workout_session.workout_exercises.create!(exercise: exercises(:two))

    assert_equal [ workout_exercises(:one), later ], workout_session.workout_exercises.to_a
  end

  test "re-adding a removed exercise goes to the end, not back to its original spot" do
    workout_session = workout_sessions(:one)
    squat = workout_exercises(:one).exercise
    pulldown = exercises(:two)

    workout_session.workout_exercises.create!(exercise: pulldown)
    workout_session.workout_exercises.find_by!(exercise: squat).destroy
    workout_session.workout_exercises.create!(exercise: squat)

    assert_equal [ pulldown, squat ], workout_session.reload.workout_exercises.map(&:exercise)
  end
end
