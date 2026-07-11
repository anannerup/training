require "test_helper"

class WorkoutExercisesControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "create adds an exercise to the workout session" do
    assert_difference -> { workout_sessions(:one).workout_exercises.count } do
      post workout_session_workout_exercises_path(workout_sessions(:one)), params: { exercise_id: exercises(:two).id }, as: :turbo_stream
    end
    assert_response :success
  end

  test "create is idempotent when the exercise is already added" do
    assert_no_difference -> { workout_sessions(:one).workout_exercises.count } do
      post workout_session_workout_exercises_path(workout_sessions(:one)), params: { exercise_id: workout_exercises(:one).exercise_id }, as: :turbo_stream
    end
    assert_response :success
  end

  test "destroy removes an exercise from the workout session" do
    assert_difference -> { WorkoutExercise.count }, -1 do
      delete workout_exercise_path(workout_exercises(:one)), as: :turbo_stream
    end
    assert_response :success
  end

  test "show displays the exercise's sets" do
    get workout_exercise_path(workout_exercises(:one))
    assert_response :success
  end

  test "show offers no next-exercise shortcut before any set is logged" do
    workout_exercise = workout_sessions(:one).workout_exercises.create!(exercise: exercises(:two))

    get workout_exercise_path(workout_exercise)

    assert_select "#next_up a", false
  end

  test "show offers a shortcut to the next exercise once a set is logged" do
    next_workout_exercise = workout_sessions(:one).workout_exercises.create!(exercise: exercises(:two))

    get workout_exercise_path(workout_exercises(:one))

    assert_select "#next_up a[href=?]", workout_exercise_path(next_workout_exercise)
  end

  test "show offers to finish the workout once the last exercise's set is logged" do
    get workout_exercise_path(workout_exercises(:one))

    assert_select "#next_up a[href=?]", workout_session_path(workout_sessions(:one)), text: "Finish workout"
  end

  test "cannot manage another user's workout exercise" do
    get workout_exercise_path(workout_exercises(:two))
    assert_response :not_found
  end
end
