require 'spec_helper'

RSpec.describe Datadog::Workers::AsyncTransport do
  let(:worker) {
    Datadog::Workers::AsyncTransport.new(
      transport: nil,
      buffer_size: 100,
      on_trace: task,
      interval: 0.5
    )
  }

  describe 'callbacks' do
    describe 'when raising errors' do
      let(:task) { proc { raise StandardError } }

      it 'does not re-raise' do
        buf = StringIO.new
        Datadog.configure { |c| c.logger = Datadog::Logger.new(buf) }

        worker.enqueue_trace(get_test_traces(1))

        expect { worker.callback_traces }.to_not raise_error

        lines = buf.string.lines
        expect(lines.count).to eq 1
      end
    end
  end

  describe 'thread naming' do
    let(:task) { proc { true } }

    after do
      worker.stop
    end

    it do
      worker.start

      expect(worker.instance_variable_get(:@worker).name).to eq described_class.name
    end
  end
end
