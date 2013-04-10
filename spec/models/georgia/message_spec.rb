require 'spec_helper'

describe Georgia::Message do
  specify {FactoryGirl.build(:georgia_message).should be_valid}

  it { should respond_to :name, :email, :subject, :message, :attachment }

  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:message)}

  it {should allow_value('whereis@waldo.com').for(:email)}
  it {should_not allow_value('waldo.com').for(:email)}
  it {should_not allow_value('whereis@waldo').for(:email)}
  it {should_not allow_value('@waldo.com').for(:email)}

  describe '.search' do

    it 'allows for full text search by query' do
      Georgia::Message.should respond_to :search
      pending 'Change test db to postgresql'
    end

  end

end