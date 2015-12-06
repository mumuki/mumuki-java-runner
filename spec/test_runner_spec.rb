require_relative 'spec_helper'

describe TestRunner do
  let(:runner) { TestRunner.new('runjunit_command' => 'runjunit') }

  describe '#run' do
    let(:file) { File.new 'spec/data/failed/SubmissionTest.java' }
    let(:result) { runner.run_compilation!(file) }

    it { expect(result[1]).to eq :failed }
    it { expect(result[0]).to include 'There was 1 failure' }

  end

  describe '#run' do
    let(:file) { File.new 'spec/data/passed/SubmissionTest.java' }
    let(:result) { runner.run_compilation!(file) }

    it { expect(result[1]).to eq :passed }
  end
end
