require 'spec_helper'

describe MessagesController, :type => :controller do
  describe 'GET new' do
    context 'given no configured smtp server' do
      before do
        @profile = FactoryGirl.create(:profile)
        sign_in @profile.user
        get :new, :profile_id => @profile.id
      end

      it 'initializes and saves a new @message' do
        msg = assigns(:message)
        expect(msg.profile).to eq(@profile)
        expect(msg).to_not be(:new_record?)
      end

      it 'shows the template' do
        expect(response).to render_template('new')
      end
    end
  end
end
