require_relative 'spec_helper'

describe TestRunner do
  let(:runner) { TestRunner.new('javac_command' => 'javac',
                                'java_command' => 'java',
                                'java_classpath' => '~/.m2/repository/org/hamcrest/hamcrest-core/1.2/hamcrest-core-1.2.jar:~/.m2/repository/junit/junit/4.12/junit-4.12.jar') }

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
