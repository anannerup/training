require "test_helper"

class ExerciseTest < ActiveSupport::TestCase
  test "requires a unique name" do
    exercise = Exercise.new(name: exercises(:one).name)
    assert_not exercise.valid?
  end

  test "cannot be destroyed once used in a workout" do
    exercise = workout_exercises(:one).exercise
    assert_not exercise.destroy
  end

  test "assigns the next position automatically" do
    exercise = Exercise.create!(name: "Deadlift")
    assert_equal Exercise.maximum(:position), exercise.position
    assert_operator exercise.position, :>, exercises(:two).position
  end
end
