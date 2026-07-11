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

  # The weight to pre-fill on the next set: the previous set logged this
  # session, or failing that the last set logged for this exercise in the
  # most recent prior session, or failing that the exercise's bar weight.
  def default_next_weight
    return set_entries.last.weight if set_entries.any?

    last_set_from_previous_session&.weight || exercise.starting_weight
  end

  def new_set_entry
    set_entries.new(weight: default_next_weight)
  end

  def next_workout_exercise
    workout_session.workout_exercises.where("position > ?", position).first
  end

  private
    def assign_position
      self.position ||= workout_session.workout_exercises.maximum(:position).to_i + 1
    end

    def last_set_from_previous_session
      previous_workout_exercise = exercise.workout_exercises
        .where.not(workout_session_id: workout_session_id)
        .joins(:workout_session)
        .where(workout_sessions: { user_id: workout_session.user_id })
        .order("workout_sessions.created_at DESC")
        .first

      previous_workout_exercise&.set_entries&.last
    end
end
