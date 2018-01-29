class GeneratePayrollJob < ApplicationJob
  queue_as :default

  def perform(first_date, second_date)
    payroll_service = PayrollService.new(first_date, second_date)
    payroll_service.generate if payroll_service.should_generate?
  end
end
