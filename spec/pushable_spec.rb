require 'spec_helper'

class PushItRealGood
  include MongoMapper::Document
  plugin Pushable
  key :name, String
end

describe Pushable do
  it "should be a module able to be included with the plugin directive" do
    PushItRealGood.should include(subject)
  end

  it "should push on all events by default" do
    PushItRealGood.push_event?(:update).should be_true
    PushItRealGood.push_event?(:create).should be_true
    PushItRealGood.push_event?(:destroy).should be_true
  end

  it "should push all attributes by default" do
    PushItRealGood.push_changes_for?(:update, :name).should be_true
  end

  it "should push to itself by default" do
    PushItRealGood.push_changes_to(:update, :name).should include(:self)
  end

  describe "class methods" do
    describe "#push" do
      it "can specify pushing a single attribute" do
        class SingleAttribute < PushItRealGood
          key :salt, String
          key :pepper, String
        end

        SingleAttribute.push :salt
        SingleAttribute.push_changes_for?(:update, :salt).should be_true
        SingleAttribute.push_changes_for?(:update, :pepper).should be_false
      end

      it "can specify pushing a multiple attributes" do
        class MultipleAttributes < PushItRealGood
          key :salt, String
          key :pepper, String
        end

        MultipleAttributes.push :salt, :pepper
        MultipleAttributes.push_changes_for? :update, :salt
        MultipleAttributes.push_changes_for?(:update, :salt).should be_true
        MultipleAttributes.push_changes_for?(:update, :pepper).should be_true
      end

      it "can specify pushing all attributes" do
        class AllAttributes < PushItRealGood
          key :salt, String
          key :pepper, String
        end

        AllAttributes.push :all
        AllAttributes.push_changes_for?(:update, :salt).should be_true
        AllAttributes.push_changes_for?(:update, :pepper).should be_true
      end

      it "can specify an event to push on" do
        class SingleEvent < PushItRealGood
          key :salt, String
          key :pepper, String
        end

        SingleEvent.push :on => :update
        SingleEvent.push_event?(:update).should be_true
        SingleEvent.push_event?(:create).should be_false
        SingleEvent.push_event?(:destroy).should be_false
      end

      it "can specify events to push on" do
        class MulitpleEvents < PushItRealGood
          key :salt, String
          key :pepper, String
        end

        MulitpleEvents.push :on => [ :create, :update ]
        MulitpleEvents.push_event?(:update).should be_true
        MulitpleEvents.push_event?(:create).should be_true
        MulitpleEvents.push_event?(:destroy).should be_false
      end

      it "can specify associations to push changes to" do
        class Salt < PushItRealGood
          belongs_to :pepper
          push :all, :to => :pepper
        end
        class Pepper < PushItRealGood
          has_one :salt
          push :all, :to => :salt
        end

        Salt.push_changes_to(:udpate, :name).should include(:pepper)
        Pepper.push_changes_to(:udpate, :name).should include(:salt)
      end
    end
  end
end
