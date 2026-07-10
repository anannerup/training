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
end
