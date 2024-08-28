class Riding < ApplicationRecord
  has_many :polls, dependent: :destroy
  has_many :polling_locations, dependent: :destroy
  accepts_nested_attributes_for :polling_locations

  validates :name, presence: true
  validates :riding_code, presence: true
  validates :province, presence: true
end
