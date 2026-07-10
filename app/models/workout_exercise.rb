class WorkoutExercise < ApplicationRecord
  belongs_to :workout_session
  belongs_to :exercise

  has_many :set_entries, -> { order(:set_number) }, dependent: :destroy

  validates :exercise_id, uniqueness: { scope: :workout_session_id }

  before_validation :assign_position, on: :create

  def summary
    return "No sets yet" if set_entries.empty?

    "#{set_entries.size} sets: #{set_entries.map { |set| "#{set.formatted_weight}x#{set.reps}" }.join(' - ')}"
  end

  private
    def assign_position
      self.position ||= workout_session.workout_exercises.maximum(:position).to_i + 1
    end
end
