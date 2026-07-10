require "test_helper"

class ExercisesControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "index lists exercises" do
    get exercises_path
    assert_response :success
  end

  test "create adds a new exercise" do
    assert_difference("Exercise.count") do
      post exercises_path, params: { exercise: { name: "Deadlift" } }
    end
    assert_redirected_to exercises_path
  end

  test "create with a duplicate name re-renders the form" do
    assert_no_difference("Exercise.count") do
      post exercises_path, params: { exercise: { name: exercises(:one).name } }
    end
    assert_response :unprocessable_entity
  end

  test "update renames an exercise" do
    patch exercise_path(exercises(:one)), params: { exercise: { name: "Incline Bench Press" } }
    assert_redirected_to exercises_path
    assert_equal "Incline Bench Press", exercises(:one).reload.name
  end

  test "destroy removes an unused exercise" do
    exercise = Exercise.create!(name: "Unused")
    assert_difference("Exercise.count", -1) do
      delete exercise_path(exercise)
    end
    assert_redirected_to exercises_path
  end

  test "destroy is blocked for an exercise used in a workout" do
    assert_no_difference("Exercise.count") do
      delete exercise_path(workout_exercises(:one).exercise)
    end
    assert_redirected_to exercises_path
  end

  test "create can mark an exercise as default selected" do
    post exercises_path, params: { exercise: { name: "Deadlift", default_selected: "1" } }
    assert Exercise.find_by(name: "Deadlift").default_selected?
  end

  test "update can toggle default selected" do
    patch exercise_path(exercises(:one)), params: { exercise: { name: exercises(:one).name, default_selected: "1" } }
    assert exercises(:one).reload.default_selected?
  end

  test "create can mark an exercise as using a barbell" do
    post exercises_path, params: { exercise: { name: "Deadlift", uses_barbell: "1" } }
    assert Exercise.find_by(name: "Deadlift").uses_barbell?
  end

  test "reorder updates positions to match the given order" do
    patch reorder_exercises_path, params: { ids: [ exercises(:two).id, exercises(:one).id ] }, as: :json
    assert_response :success

    assert_equal 1, exercises(:two).reload.position
    assert_equal 2, exercises(:one).reload.position
  end
end
