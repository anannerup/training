class SetEntry < ApplicationRecord
  belongs_to :workout_exercise

  validates :weight, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :reps, presence: true, numericality: { greater_than: 0, only_integer: true }

  before_validation :assign_set_number, on: :create

  def formatted_weight
    weight == weight.to_i ? weight.to_i : weight
  end

  private
    def assign_set_number
      self.set_number ||= workout_exercise.set_entries.maximum(:set_number).to_i + 1
    end
end
