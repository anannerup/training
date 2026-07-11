require "test_helper"

class SetEntriesControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:one)) }

  test "create logs a new set" do
    assert_difference -> { workout_exercises(:one).set_entries.count } do
      post workout_exercise_set_entries_path(workout_exercises(:one)), params: { set_entry: { weight: 60, reps: 6 } }, as: :turbo_stream
    end
    assert_response :success
  end

  test "create reveals the next-exercise shortcut once the first set is logged" do
    workout_exercise = workout_sessions(:one).workout_exercises.create!(exercise: exercises(:two))

    post workout_exercise_set_entries_path(workout_exercise), params: { set_entry: { weight: 60, reps: 6 } }, as: :turbo_stream

    assert_select "turbo-stream[action=replace][target=next_up] a", text: "Finish workout"
  end

  test "destroy hides the next-exercise shortcut when the last set is removed" do
    delete set_entry_path(set_entries(:one)), as: :turbo_stream

    assert_select "turbo-stream[action=replace][target=next_up] a", false
  end

  test "create with invalid params does not log a set" do
    assert_no_difference -> { workout_exercises(:one).set_entries.count } do
      post workout_exercise_set_entries_path(workout_exercises(:one)), params: { set_entry: { weight: 60, reps: 0 } }, as: :turbo_stream
    end
    assert_response :unprocessable_entity
  end

  test "edit renders the inline form" do
    get edit_set_entry_path(set_entries(:one))
    assert_response :success
  end

  test "update corrects a set" do
    patch set_entry_path(set_entries(:one)), params: { set_entry: { weight: 65, reps: 5 } }, as: :turbo_stream
    assert_response :success
    assert_equal 5, set_entries(:one).reload.reps
  end

  test "destroy removes a set" do
    assert_difference -> { SetEntry.count }, -1 do
      delete set_entry_path(set_entries(:one)), as: :turbo_stream
    end
  end

  test "cannot manage another user's set" do
    get edit_set_entry_path(set_entries(:two))
    assert_response :not_found
  end
end
