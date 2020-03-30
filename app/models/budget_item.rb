class BudgetItem < ApplicationRecord
  belongs_to :camp
  validates :min_budget, :numericality => { :greater_than_or_equal_to => 0 }, allow_blank: true
  validates :max_budget, :numericality => { :greater_than_or_equal_to => 0 }, allow_blank: true

  after_save :align_parent_budget
  after_destroy :align_parent_budget

  def align_parent_budget
    self.camp.align_budget
  end
end
