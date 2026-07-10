require "test_helper"

class SetEntryTest < ActiveSupport::TestCase
  test "assigns the next set number within its workout exercise automatically" do
    set_entry = workout_exercises(:one).set_entries.create!(weight: 60, reps: 6)
    assert_equal set_entries(:one).set_number + 1, set_entry.set_number
  end

  test "requires positive reps" do
    set_entry = workout_exercises(:one).set_entries.build(weight: 60, reps: 0)
    assert_not set_entry.valid?
  end

  test "requires a non-negative weight" do
    set_entry = workout_exercises(:one).set_entries.build(weight: -1, reps: 6)
    assert_not set_entry.valid?
  end

  test "formatted_weight drops trailing zero for whole numbers" do
    assert_equal 60, SetEntry.new(weight: 60.0).formatted_weight
    assert_equal 62.5, SetEntry.new(weight: 62.5).formatted_weight
  end
end
