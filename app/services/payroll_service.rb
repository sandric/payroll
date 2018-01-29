class PayrollService
  attr_reader :first_day, :second_day, :payroll

  def initialize(first_day, second_day)
    @first_day = first_day
    @second_day = second_day
    @payroll = Payroll.new
  end

  def generate
    previous_payroll = Payroll.ordered.last

    if previous_payroll
      starts_at = previous_payroll.ends_at + 1.day

      payroll.starts_at = starts_at
      payroll.ends_at = end_date(starts_at)
    else
      payroll.starts_at = DateTime.current.beginning_of_year.change(day: @first_day)
      payroll.ends_at = DateTime.current.beginning_of_year.change(day: @second_day - 1)
    end

    payroll.save

    return self
  end

  def should_generate?(date = Date.today)
    previous_payroll = Payroll.ordered.last
    return !previous_payroll || previous_payroll.ends_at < date
  end

  private

  def end_date(starts_at)
    first_greater = [@first_day, @second_day].find { |day| day > starts_at.day }

    if first_greater.nil?
      starts_at.advance(months: 1).change(day: @first_day) - 1.day
    else
      starts_at.change(day: first_greater) - 1.day
    end
  end
end
