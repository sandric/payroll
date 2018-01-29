require 'rails_helper'

RSpec.describe PayrollService do
  describe '.new' do
    let!(:first_date) { 5 }
    let!(:second_date) { 20 }

    context 'if no previous payroll' do
      it 'generates first payroll for current date' do
        payroll = PayrollService.new(first_date, second_date).generate.payroll

        expect(payroll.starts_at).to eq DateTime.parse('5 Jan 2018')
        expect(payroll.ends_at).to eq DateTime.parse('19 Jan 2018')
      end
    end

    context 'if previous payrolls exists' do
      it 'generates payroll next to previous' do
        payroll_service = PayrollService.new(first_date, second_date)
        payroll_service.generate
        payroll = payroll_service.generate.payroll

        expect(payroll.starts_at).to eq DateTime.parse("20 Jan 2018")
        expect(payroll.ends_at).to eq DateTime.parse("4 Feb 2018")
      end

      context 'if payroll dates updated' do
        it 'payroll generated with second date increases' do
          second_date = 31
          payroll_service = PayrollService.new(first_date, second_date)
          payroll_service.generate
          payroll = payroll_service.generate.payroll

          expect(payroll.starts_at).to eq DateTime.parse("31 Jan 2018")
          expect(payroll.ends_at).to eq DateTime.parse("4 Feb 2018")
        end

        it 'payroll generated with second date decreases' do
          second_date = 15
          payroll_service = PayrollService.new(first_date, second_date)
          payroll_service.generate
          payroll = payroll_service.generate.payroll

          expect(payroll.starts_at).to eq DateTime.parse("15 Jan 2018")
          expect(payroll.ends_at).to eq DateTime.parse("4 Feb 2018")
        end


        it 'payroll generated with first date increases' do
          first_date = 7
          payroll_service = PayrollService.new(first_date, second_date)
          3.times { payroll_service.generate }

          payroll = payroll_service.generate.payroll

          expect(payroll.starts_at).to eq DateTime.parse("20 Feb 2018")
          expect(payroll.ends_at).to eq DateTime.parse("6 March 2018")
        end

        it 'payroll generated with first date decreases' do
          first_date = 3
          payroll_service = PayrollService.new(first_date, second_date)
          3.times { payroll_service.generate }

          payroll = payroll_service.generate.payroll

          expect(payroll.starts_at).to eq DateTime.parse("20 Feb 2018")
          expect(payroll.ends_at).to eq DateTime.parse("2 March 2018")
        end
      end

      describe ".should_generate?" do
        before { Timecop.freeze("5 Jan 2018".to_datetime) }
        let(:payroll_service) { PayrollService.new(first_date, second_date) }

        it 'returns true if no payload exists for current date' do
          expect(payroll_service.should_generate?).to be_truthy
        end

        it 'returns false if payload exists for current date' do
          payroll_service.generate

          expect(payroll_service.should_generate?).to be_falsy
        end
      end
    end
  end
end
