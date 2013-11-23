require_relative '../../../app/models/concerns/retry_methods.rb'
require 'active_record'

describe RetryMethods do
  let(:dummy) { Dummy.new }
  context '#retry_on_error' do
    context 'for zero retries' do
      it 'executes &block on no error and does not raise error' do
        expect {
          dummy.retry_on_error(DummyError, 0) { dummy.dont_raise }
        }.not_to raise_error
        expect(dummy.count).to eq 1
      end

      it 'executes &block once on one error and raises error' do
        expect {
          dummy.retry_on_error(DummyError, 0) { dummy.raise_once DummyError }
        }.to raise_error DummyError
        expect(dummy.count).to eq 1
      end
    end

    context 'for one (or more) retries' do
      it 'executes &block twice on one error and does not raise error' do
        expect {
          dummy.retry_on_error(DummyError) { dummy.raise_once DummyError }
        }.not_to raise_error
        expect(dummy.count).to eq 2
      end

      it 'executes &block twice on two errors and raises error' do
        expect {
          dummy.retry_on_error(DummyError) { dummy.raise_twice DummyError }
        }.to raise_error DummyError
        expect(dummy.count).to eq 2
      end
    end
  end

  context '#save_and_retry_on_not_unique' do
    it 'calls #retry_on_error for ActiveRecord::RecordNotUnique' do
      expect(dummy).to receive(:retry_on_error).with(ActiveRecord::RecordNotUnique)
      dummy.save_and_retry_on_unique
    end

    it 'calls #save and passes the arguments' do
      expect(dummy).to receive(:save).with(:dummy_args)
      dummy.save_and_retry_on_unique :dummy_args
    end
  end

end

class Dummy
  include RetryMethods
  attr_accessor :count
  def initialize; @count = 0; end
  def save *args; end
  def dont_raise; @count += 1; end
  def raise_once  ex; raise_n ex, 1; end
  def raise_twice ex; raise_n ex, 2; end
  def raise_n ex, n
    @count += 1
    raise ex if @count <= n
  end
end

class DummyError < StandardError; end
