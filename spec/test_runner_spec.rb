require_relative 'spec_helper'

describe TestRunner do
  let(:runner) { TestRunner.new('javac_command' => 'javac -cp  ~/.m2/repository/junit/junit/4.12/junit-4.12.jar',
                                'java_command' => 'java -cp  ~/.m2/repository/junit/junit/4.12/junit-4.12.jar') }

  describe '#run' do
    let(:dir) { 'spec/data/failed' }
    let(:result) { runner.run_test_dir!(dir) }

    it { expect(result).to eq ['', :failed] }
  end

  describe '#run' do
    let(:dir) { 'spec/data/passed' }
    let(:result) { runner.run_test_dir!(dir) }

    it { expect(result).to eq ['', :passed] }
  end
end
