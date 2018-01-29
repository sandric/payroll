every :day, at: '00:01 am' do
  runner "GeneratePayrollJob.perform_later(5, 20)"
end
