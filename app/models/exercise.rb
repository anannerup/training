class Exercise < ApplicationRecord
  has_many :workout_exercises, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true

  before_validation :assign_position, on: :create

  private
    def assign_position
      self.position ||= Exercise.maximum(:position).to_i + 1
    end
end
