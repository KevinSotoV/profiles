require 'spec_helper'

describe Profile do
  describe 'gender' do
    subject { Factory.build(:profile) }

    it 'accepts a nil gender' do
      subject.gender = 'nil'
      subject.gender.should be_nil
    end
  end

  describe '#set_image_urls' do
    before do
      User.any_instance.stub(:gravatar_hash).and_return('abc123')
      @profile = Factory.build(:profile)
      @profile.set_image_urls
    end

    it 'sets the small_image_url' do
      @profile.small_image_url.should eq('http://www.gravatar.com/avatar/abc123?s=50')
    end

    it 'sets the full_image_url' do
      @profile.full_image_url.should eq('http://www.gravatar.com/avatar/abc123?s=180')
    end

    it 'calls user.gravatar_hash' do
      @profile.user.should have_received(:gravatar_hash)
    end
  end
end
