class Poll < ApplicationRecord
  belongs_to :riding
  belongs_to :polling_location, optional: true

  validates :number, presence: true
  validates :number, uniqueness: { scope: :riding_id }
end
