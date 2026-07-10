class SetEntriesController < ApplicationController
  before_action :set_workout_exercise, only: :create
  before_action :set_set_entry, only: %i[edit update destroy]

  def create
    @set_entry = @workout_exercise.set_entries.new(set_entry_params)

    if @set_entry.save
      render :create
    else
      render :create_error, status: :unprocessable_entity
    end
  end

  def edit
    @workout_exercise = @set_entry.workout_exercise
  end

  def update
    @workout_exercise = @set_entry.workout_exercise

    if @set_entry.update(set_entry_params)
      render :update
    else
      render :update_error, status: :unprocessable_entity
    end
  end

  def destroy
    @workout_exercise = @set_entry.workout_exercise
    @set_entry.destroy
  end

  private
    def set_workout_exercise
      @workout_exercise = WorkoutExercise.joins(:workout_session).merge(Current.user.workout_sessions).find(params[:workout_exercise_id])
    end

    def set_set_entry
      @set_entry = SetEntry.joins(workout_exercise: :workout_session).merge(Current.user.workout_sessions).find(params[:id])
    end

    def set_entry_params
      params.expect(set_entry: [ :weight, :reps ])
    end
end
