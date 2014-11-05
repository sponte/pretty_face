require 'spec_helper'
require 'cucumber/ast/step'

describe PrettyFace::Formatter::Html do
  let(:step_mother) { double('step_mother') }
  let(:formatter) { Html.new(step_mother, nil, nil) }
  let(:parameter) { double('parameter') }
  let(:step) { Cucumber::Ast::Step.new(1, 'Given', 'A cucumber Step') }

  context 'when building the header for the main page' do
    it 'should know the start time' do
      formatter.stub(:make_output_directories)
      formatter.before_features(nil)
      formatter.start_time.should eq Time.now.strftime('%a %B %-d, %Y at %H:%M:%S')
    end

    it 'should know how long it takes' do
      formatter.should_receive(:generate_report)
      formatter.should_receive(:copy_images)
      formatter.should_receive(:copy_stylesheets)
      formatter.stub(:make_output_directories)
      formatter.before_features(nil)

      formatter.after_features(nil)
      formatter.total_duration.should include '0.0'
    end
  end

  context 'when building the report for scenarios' do
    it 'should track number of scenarios' do
      step_mother.should_receive(:scenarios).and_return([1,2,3])
      formatter.scenario_count.should eq 3
    end

    it 'should keep track of passing scenarios' do
      step_mother.should_receive(:scenarios).with(:passed).and_return([1,2])
      step_mother.should_receive(:scenarios).and_return([1,2])
      formatter.scenarios_summary_for(:passed).should == "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it 'should keep track of failing scenarios' do
      step_mother.should_receive(:scenarios).with(:failed).and_return([1,2])
      step_mother.should_receive(:scenarios).and_return([1,2])
      formatter.scenarios_summary_for(:failed).should == "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it 'should keep track of pending scenarios' do
      step_mother.should_receive(:scenarios).with(:pending).and_return([1,2])
      step_mother.should_receive(:scenarios).and_return([1,2])
      formatter.scenarios_summary_for(:pending).should == "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it 'should keep track of undefined scenarios' do
      step_mother.should_receive(:scenarios).with(:undefined).and_return([1,2])
      step_mother.should_receive(:scenarios).and_return([1,2])
      formatter.scenarios_summary_for(:undefined).should == "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it 'should keep track of skipped scenarios' do
      step_mother.should_receive(:scenarios).with(:skipped).and_return([1,2])
      step_mother.should_receive(:scenarios).and_return([1,2])
      formatter.scenarios_summary_for(:skipped).should == "2 <span class=\"percentage\">(100.0%)</span>"
    end
  end

  context 'when building the report for steps' do
    it 'should track number of steps' do
      step_mother.should_receive(:steps).and_return([1,2])
      formatter.step_count.should == 2
    end

    it 'should keep track of passing steps' do
      step_mother.should_receive(:steps).with(:passed).and_return([1,2])
      step_mother.should_receive(:steps).and_return([1,2])
      formatter.steps_summary_for(:passed).should == "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it 'should keep track of failing steps' do
      step_mother.should_receive(:steps).with(:failed).and_return([1,2])
      step_mother.should_receive(:steps).and_return([1,2])
      formatter.steps_summary_for(:failed).should == "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it 'should keep track of skipped steps' do
      step_mother.should_receive(:steps).with(:skipped).and_return([1,2])
      step_mother.should_receive(:steps).and_return([1,2])
      formatter.steps_summary_for(:skipped).should == "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it 'should keep track of pending steps' do
      step_mother.should_receive(:steps).with(:pending).and_return([1,2])
      step_mother.should_receive(:steps).and_return([1,2])
      formatter.steps_summary_for(:pending).should == "2 <span class=\"percentage\">(100.0%)</span>"
    end

    it 'should keep track of undefined steps' do
      step_mother.should_receive(:steps).with(:undefined).and_return([1,2])
      step_mother.should_receive(:steps).and_return([1,2])
      formatter.steps_summary_for(:undefined).should == "2 <span class=\"percentage\">(100.0%)</span>"
    end
  end

  context 'when embedding an image' do
    before(:each) do
      cuke_feature = double('cuke_feature')
      cuke_feature.should_receive(:description)
      report_feature = ReportFeature.new(cuke_feature, 'foo')
      formatter.report.features << report_feature
      @scenario = ReportScenario.new(nil)
      formatter.report.current_feature.scenarios << @scenario
      File.stub(:dirname).and_return('')
      FileUtils.stub(:cp)
    end

    it 'should generate an id' do
      formatter.embed('image.png', 'image/png', 'the label')
      puts @scenario.images.inspect
      @scenario.images[0].id.should == 'img_0'
    end

    it 'should allow base64 encoded images' do
      base64_image = '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'
      formatter.embed("data:image/png;base64,#{base64_image}", 'image/png', 'testing')
      @scenario.images[0].src.should include('base64')
    end

    it 'should get the filename from the src' do
      formatter.embed('directory/image.png', 'image/png', 'the label')
      @scenario.images[0].src.should == 'image.png'
    end

    it 'should get the image label' do
      formatter.embed('directory/image.png', 'image/png', 'the label')
      @scenario.images[0].label.should == 'the label'
    end

    it 'scenario should know if it has an image' do
      formatter.embed('directory/image.png', 'image/png', 'the label')
      @scenario.should have_images
    end

    it 'should copy the image to the output directory' do
      FileUtils.should_receive(:cp).with('directory/image.png', '/images')
      formatter.embed('directory/image.png', 'image/png', 'the label')
    end
  end
end
