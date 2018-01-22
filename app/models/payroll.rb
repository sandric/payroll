class Payroll < ActiveRecord::Base
  scope :ordered, -> { order(starts_at: :asc) }
end
