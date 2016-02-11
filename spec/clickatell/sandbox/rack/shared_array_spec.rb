require 'spec_helper'

describe Clickatell::Sandbox::Rack::SharedArray do
  subject { Clickatell::Sandbox::Rack::SharedArray.new }
  before :each do
    subject.clear
  end

  describe '<<' do
    it 'adds the message' do
      subject << {test: true}
      expect(subject.first).to eq(test: true)
    end

    it 'adds 2 messages' do
      subject << {test: true}
      subject << {another: true}
      expect(subject.to_a).to eq([{another: true},{test: true}])
    end

    it 'limits to 25' do
      27.times do |i|
        subject << {'text' => i.to_s, 'to' => ['27711234567']}
      end

      expect(subject.size).to eq(25)

      expect(subject.to_a.first).to eq('text' => '26', 'to' => ['27711234567'])
      expect(subject.to_a.last).to eq('text' => '2', 'to' => ['27711234567'])
    end
  end
end
