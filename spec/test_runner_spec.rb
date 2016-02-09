require_relative 'spec_helper'

describe 'running' do
  let(:runner) { TestHook.new('runjunit_command' => 'runjunit') }

  describe '#run' do
    context 'when test does not compile' do
      let(:file) { File.new 'spec/data/errored/SubmissionTest.java' }
      let(:result) { runner.run!(file) }

      it { expect(result[1]).to eq :errored }
      it { expect(result[0]).to include 'error: reached end of file while parsing' }

    end

    context 'when test fails' do
      let(:file) { File.new 'spec/data/failed/SubmissionTest.java' }
      let(:result) { runner.run!(file) }

      it { expect(result[1]).to eq :failed }
      it { expect(result[0]).to include 'There was 1 failure' }

    end

    context 'when test passes' do
      let(:file) { File.new 'spec/data/passed/SubmissionTest.java' }
      let(:result) { runner.run!(file) }

      it { expect(result[1]).to eq :passed }
    end
  end
end
