require "test_helper"

class WorkoutSessionsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "index lists the current user's workout sessions" do
    get workout_sessions_path
    assert_response :success
  end

  test "create starts a new workout session for the current user" do
    assert_difference -> { users(:one).workout_sessions.count } do
      post workout_sessions_path
    end
    assert_redirected_to edit_workout_session_path(WorkoutSession.last)
  end

  test "create automatically adds default-selected exercises" do
    default_exercise = Exercise.create!(name: "Deadlift", default_selected: true)

    post workout_sessions_path

    workout_session = WorkoutSession.last
    assert_includes workout_session.exercises, default_exercise
  end

  test "create does not add exercises that aren't default selected" do
    post workout_sessions_path

    workout_session = WorkoutSession.last
    assert_not_includes workout_session.exercises, exercises(:one)
  end

  test "edit lists all exercises" do
    get edit_workout_session_path(workout_sessions(:one))
    assert_response :success
  end

  test "show displays the session's exercises" do
    get workout_session_path(workout_sessions(:one))
    assert_response :success
  end

  test "cannot view another user's workout session" do
    get workout_session_path(workout_sessions(:two))
    assert_response :not_found
  end

  test "destroy removes the workout session and its exercises and sets" do
    workout_session = workout_sessions(:one)

    assert_difference [ "WorkoutSession.count", "WorkoutExercise.count", "SetEntry.count" ], -1 do
      delete workout_session_path(workout_session)
    end
    assert_redirected_to workout_sessions_path
  end

  test "cannot delete another user's workout session" do
    assert_no_difference "WorkoutSession.count" do
      delete workout_session_path(workout_sessions(:two))
    end
    assert_response :not_found
  end
end
