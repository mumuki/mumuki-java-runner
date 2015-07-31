require_relative 'spec_helper'

describe TestRunner do
  let(:runner) { TestRunner.new({'javac_command' => 'javac'}) }

  describe '#run' do
    let(:dir) { OpenStruct.new(path: './data/failed/SubmissionSpec.java') }
    let(:result) { runner.run_test_dir!(dir) }

    it { expect(result).to be ['', :failed] }
  end

  describe '#run' do
    let(:dir) { OpenStruct.new(path: './data/passed/SubmissionSpec.java') }
    let(:result) { runner.run_test_dir!(dir) }

    it { expect(result).to be ['', :passed] }
  end
end
