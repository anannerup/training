class WorkoutSessionsController < ApplicationController
  before_action :set_workout_session, only: %i[edit show destroy]

  def index
    @workout_sessions = Current.user.workout_sessions.order(created_at: :desc)
  end

  def create
    @workout_session = Current.user.workout_sessions.create!
    redirect_to edit_workout_session_path(@workout_session)
  end

  def edit
    @exercises = Exercise.order(:position)
    @workout_exercises_by_exercise_id = @workout_session.workout_exercises.index_by(&:exercise_id)
  end

  def show
    @workout_exercises = @workout_session.workout_exercises.includes(:exercise, :set_entries)
  end

  def destroy
    @workout_session.destroy
    redirect_to workout_sessions_path, notice: "Workout deleted."
  end

  private
    def set_workout_session
      @workout_session = Current.user.workout_sessions.find(params[:id])
    end
end
