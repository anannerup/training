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

  test "default_selected scope only returns exercises marked as default" do
    default_exercise = Exercise.create!(name: "Deadlift", default_selected: true)

    assert_includes Exercise.default_selected, default_exercise
    assert_not_includes Exercise.default_selected, exercises(:one)
  end

  test "starting_weight is the bar weight when it uses a barbell" do
    exercise = Exercise.create!(name: "Deadlift", uses_barbell: true)
    assert_equal Exercise::BARBELL_WEIGHT, exercise.starting_weight
  end

  test "starting_weight is zero when it doesn't use a barbell" do
    exercise = Exercise.create!(name: "Lat Pulldown", uses_barbell: false)
    assert_equal 0, exercise.starting_weight
  end
end
