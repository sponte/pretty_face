require 'spec_helper'

module PrettyFace::Formatter
  class Html
    def customization_directory
      nil
    end
  end
end

describe PrettyFace::Formatter::Html do
  let(:formatter) { Html.new(nil, nil, nil) }

  context "when not customizing the report" do
    it "indicates that there are no custom components" do
      formatter.custom_suite_header?.should == false
      formatter.custom_feature_header?.should == false
      formatter.send(:logo_file).should == nil
    end

  end

end
