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

  test "default_next_weight uses the previous set logged this session first" do
    workout_exercise = workout_sessions(:one).workout_exercises.create!(exercise: exercises(:two))
    workout_exercise.set_entries.create!(weight: 60, reps: 6)

    assert_equal 60, workout_exercise.reload.default_next_weight
  end

  test "default_next_weight falls back to the last set from the most recent previous session" do
    exercise = exercises(:two)
    older_session = users(:one).workout_sessions.create!(created_at: 2.days.ago)
    newer_session = users(:one).workout_sessions.create!(created_at: 1.day.ago)

    older_session.workout_exercises.create!(exercise: exercise).set_entries.create!(weight: 40, reps: 8)
    newer_session.workout_exercises.create!(exercise: exercise).set_entries.create!(weight: 50, reps: 6)

    today_workout_exercise = workout_sessions(:one).workout_exercises.create!(exercise: exercise)

    assert_equal 50, today_workout_exercise.default_next_weight
  end

  test "default_next_weight falls back to the exercise's starting weight with no history" do
    exercise = Exercise.create!(name: "New Move", uses_barbell: true)
    workout_exercise = workout_sessions(:one).workout_exercises.create!(exercise: exercise)

    assert_equal Exercise::BARBELL_WEIGHT, workout_exercise.default_next_weight
  end

  test "default_next_weight only inherits from the same user's history" do
    workout_exercises(:two).set_entries.create!(weight: 999, reps: 1)

    workout_exercise = workout_sessions(:one).workout_exercises.create!(exercise: exercises(:two))

    assert_equal exercises(:two).starting_weight, workout_exercise.default_next_weight
  end

  test "next_workout_exercise returns the following exercise in position order" do
    second = workout_sessions(:one).workout_exercises.create!(exercise: exercises(:two))

    assert_equal second, workout_exercises(:one).next_workout_exercise
  end

  test "next_workout_exercise returns nil for the last exercise in the session" do
    assert_nil workout_exercises(:one).next_workout_exercise
  end
end
