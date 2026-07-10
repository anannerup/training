class WorkoutExercisesController < ApplicationController
  before_action :set_workout_session, only: %i[create reorder]
  before_action :set_workout_exercise, only: %i[destroy show]

  def create
    @exercise = Exercise.find(params[:exercise_id])
    @workout_exercise = @workout_session.workout_exercises.find_or_create_by!(exercise: @exercise)
  end

  def destroy
    @workout_session = @workout_exercise.workout_session
    @exercise = @workout_exercise.exercise
    @workout_exercise.destroy
  end

  def show
    @set_entries = @workout_exercise.set_entries
  end

  def reorder
    params.expect(ids: []).each_with_index do |id, index|
      @workout_session.workout_exercises.where(id: id).update_all(position: index + 1)
    end

    head :ok
  end

  private
    def set_workout_session
      @workout_session = Current.user.workout_sessions.find(params[:workout_session_id])
    end

    def set_workout_exercise
      @workout_exercise = WorkoutExercise.joins(:workout_session).merge(Current.user.workout_sessions).find(params[:id])
    end
end
