require_relative 'spec_helper'

describe TestRunner do
  let(:runner) { TestRunner.new('javac_command' => 'javac',
                                'java_command' => 'java',
                                'java_classpath' => '.heroku/vendor/hamcrest-core-1.2.jar:.heroku/vendor/junit-4.12.jar') }

  describe '#run' do
    let(:dir) { 'spec/data/failed' }
    let(:result) { runner.run_test_dir!(dir) }

    it { expect(result[1]).to eq :failed }
    it { expect(result[0]).to include 'There was 1 failure' }

  end

  describe '#run' do
    let(:dir) { 'spec/data/passed' }
    let(:result) { runner.run_test_dir!(dir) }

    it { expect(result[1]).to eq :passed }
  end
end
