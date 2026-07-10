class ExercisesController < ApplicationController
  before_action :set_exercise, only: %i[edit update destroy]

  def index
    @exercises = Exercise.order(:position)
  end

  def new
    @exercise = Exercise.new
  end

  def create
    @exercise = Exercise.new(exercise_params)

    if @exercise.save
      redirect_to exercises_path, notice: "Exercise added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @exercise.update(exercise_params)
      redirect_to exercises_path, notice: "Exercise updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @exercise.destroy
      redirect_to exercises_path, notice: "Exercise removed."
    else
      redirect_to exercises_path, alert: "Can't remove an exercise that's used in a workout."
    end
  end

  def reorder
    params.expect(ids: []).each_with_index do |id, index|
      Exercise.where(id: id).update_all(position: index + 1)
    end

    head :ok
  end

  private
    def set_exercise
      @exercise = Exercise.find(params[:id])
    end

    def exercise_params
      params.expect(exercise: [ :name, :default_selected, :uses_barbell ])
    end
end
