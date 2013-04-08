require 'spec_helper'

describe User do
  before do
    @token = {
      "provider"     => "facebook",
      "uid"          => "000000001",
      "info"    => {
        "image"      => "http://graph.facebook.com/000000001/picture?type=square"
      },
      "extra"        => {
        "raw_info"   => {
          "id"       => "502335050",
          "name"     => "John Doe",
          "link"     => "http://www.facebook.com/seven1m",
          "username" => "seven1m",
          "gender"   => "male",
          "email"    => "john@example.com",
          "timezone" => -5,
          "location" => {
            "id"     => "109436565740998",
            "name"   => "Tulsa, Oklahoma"
          }
        }
      },
      "credentials"  => {
        "token"      => "abc123"
      }
    }
    Profile.any_instance.stub(:update_friends!)
  end

  context 'given an existing facebook uid' do
    before do
      @user = FactoryGirl.create(:user, :provider => 'facebook', :uid => @token['uid'])
    end

    subject { User.find_and_update(@token) }

    it 'reuses the existing user record' do
      expect(subject.id).to eq(@user.id)
    end

    it 'updates the profile' do
      expect(subject.profile.name).to eq('John Doe')
    end

    it 'updates the email' do
      expect(subject.email).to eq('john@example.com')
    end
  end

  context 'given a new facebook uid with an existing email address' do
    before do
      @user = FactoryGirl.create(:user, :email => 'john@example.com')
    end

    subject { User.find_and_update(@token) }

    it 'reuses the existing user record' do
      expect(subject.id).to eq(@user.id)
    end

    it 'updates the uid' do
      expect(subject.provider).to eq('facebook')
      expect(subject.uid).to eq('000000001')
    end
  end

  context 'given a new facebook uid and new email address' do
    it 'creates a new user' do
      expect {
        User.find_and_update(@token)
      }.to change(User, :count).by(1)
    end
  end

  context 'given a new user with provider=nil and thirteen_or_older=false' do
    before do
      @user = FactoryGirl.build(:user, :thirteen_or_older => false)
    end

    it 'validates thirteen or older' do
      expect(@user.errors[:thirteen_or_older]).to be_true
    end
  end

  context 'given a new user with provider=nil and thirteen_or_older=nil' do
    before do
      @user = FactoryGirl.build(:user, :thirteen_or_older => nil)
    end

    it 'validates thirteen or older' do
      expect(@user.errors[:thirteen_or_older]).to be_true
    end
  end

  context 'given an admin role' do
    before do
      @user = FactoryGirl.build(:user, :roles => [:admin])
    end

    it 'allows the new_profile notification flag to be set' do
      @user.notifications << :new_profile
      expect(@user).to be_valid
    end
  end

  context 'given no admin role' do
    before do
      @user = FactoryGirl.build(:user)
    end

    it 'does not allow the new_profile notification flag to be set' do
      @user.notifications << :new_profile
      expect(@user).to_not be_valid
      expect(@user.errors[:notifications]).to have(1).error
    end
  end
end
