class PayrollsController < ApplicationController

  before_action :new_payroll, only: [:index]

  def index
    @payrolls = Payroll.all.ordered
  end

  def create
    PayrollService.new(5, 20).generate

    redirect_to action: :index
  end

  def destroy
    @payroll = Payroll.find params[:id]

    if @payroll.destroy
      redirect_to action: :index
    end
  end

  private

  def new_payroll
    @new_payroll = Payroll.new
  end
end
