require 'spec_helper'

describe Pushable do
  it "should be a module able to be included with the plugin directive" do
    class PushItRealGood
      include MongoMapper::Document
      plugin Pushable
    end

    PushItRealGood.should include(subject)
  end
end
