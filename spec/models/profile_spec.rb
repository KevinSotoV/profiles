require 'spec_helper'

describe Profile do
  subject { FactoryGirl.build(:profile) }

  it 'accepts a nil gender' do
    subject.gender = 'nil'
    expect(subject.gender).to be_nil
  end
end
