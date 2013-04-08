require 'spec_helper'

describe Message do
  describe '#set_method' do
    context 'given no smtp server' do
      before do
        SMTP_OK = false
        @message = FactoryGirl.build(:message)
      end

      it 'sets the method to "mailto"' do
        expect(@message.method).to eq('mailto')
      end
    end

    context 'given an smtp server' do
      before do
        SMTP_OK = true
        @message = FactoryGirl.build(:message)
      end

      it 'sets the method to "mailto"' do
        expect(@message.method).to eq('smtp')
      end
    end
  end
end
