class PollingLocation < ApplicationRecord
  belongs_to :riding
  has_many :polls
  accepts_nested_attributes_for :polls

  validates :title, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validate :validate_postal_code
  validates :title, uniqueness: { scope: [:address, :city, :postal_code] }
  
  after_validation :format_postal_code
  after_save :create_polls_list

  def format_postal_code
    self.postal_code = self.postal_code.upcase.scan(/[A-Z0-9]/).insert(3, ' ').join if self.postal_code.present?
  end

  def validate_postal_code
    unless self.postal_code.present? && /[ABCEGHJKLMNPRSTVXY]\d[ABCEGHJ-NPRSTV-Z][ ]?\d[ABCEGHJ-NPRSTV-Z]\d/.match?(self.postal_code.upcase)
      errors.add(:postal_code, "must be valid")
    end
  end

  def polls_list
    self.polls.map { |p| p.number }.join(", ")
  end
  
  def polls_list=(new_value)
    list = new_value.split(/,\s+/)
    
    if self.persisted?
      self.polls = list.map do |number| 
        self.polls.where(riding: self.riding).where('number = ?', number).first || self.polls.create(riding: self.riding, number: number) 
      end
    else
      @unsaved_polls_list = list
    end
  end

  
  def create_polls_list
    if @unsaved_polls_list.present?
      self.polls = @unsaved_polls_list.map do |number| 
        self.polls.where(riding: self.riding).where('number = ?', number).first || self.polls.create(riding: self.riding, number: number) 
      end
      @unsaved_polls_list = nil
    end
  end
end
