describe Setting do
  subject { Setting }

  describe '.s' do
    it "returns the nested object value given a key of foo.bar format" do
      expect(subject.s('site.name')).to_not be_nil
      expect(subject.s('site.name')).to eq(Setting::SETTINGS['SITE_NAME'])
    end
  end
end
