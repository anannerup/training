class Exercise < ApplicationRecord
  BARBELL_WEIGHT = 20

  has_many :workout_exercises, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true

  scope :default_selected, -> { where(default_selected: true) }

  before_validation :assign_position, on: :create

  def starting_weight
    uses_barbell? ? BARBELL_WEIGHT : 0
  end

  private
    def assign_position
      self.position ||= Exercise.maximum(:position).to_i + 1
    end
end
