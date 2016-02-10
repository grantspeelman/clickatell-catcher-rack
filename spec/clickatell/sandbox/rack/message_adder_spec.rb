require 'spec_helper'

describe Clickatell::Sandbox::Rack::MessageAdder do
  let(:messages) { [] }
  subject { Clickatell::Sandbox::Rack::MessageAdder.new(messages) }

  def add_json_message(message)
    subject.add(MultiJson.dump(message))
  end

  def rack_status
    subject.rack_response[0]
  end

  def rack_headers
    subject.rack_response[1]
  end

  def parsed_rack_response
    MultiJson.load(subject.rack_response[2].first)
  end

  def parsed_rack_response_message
    parsed_rack_response['data']['message']
  end

  describe 'single message' do
    before :each do
      add_json_message('text' => 'This is a message', 'to' => ['27711234567'])
    end

    it 'adds the message' do
      expect(messages).to contain_exactly('text' => 'This is a message', 'to' => ['27711234567'])
    end

    it 'sets correct status' do
      expect(rack_status).to eq(200)
    end

    it 'sets correct headers' do
      expect(rack_headers).to eq('Content-Type' => 'application/json')
    end

    it 'sets correct message body' do
      expect(parsed_rack_response_message).to contain_exactly('accepted' => true,
                                                              'to' => '27711234567',
                                                              'apiMessageId' => '1')
    end
  end
end
