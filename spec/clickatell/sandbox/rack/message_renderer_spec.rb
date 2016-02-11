require 'spec_helper'

describe Clickatell::Sandbox::Rack::MessageAdder do
  let(:messages) { [] }
  subject { Clickatell::Sandbox::Rack::MessagesRenderer.new(messages) }

  def rack_status
    subject.rack_response[0]
  end

  def rack_headers
    subject.rack_response[1]
  end

  def rack_body
    subject.rack_response[2].first
  end

  describe 'render single recipient' do
    before :each do
      messages.push('text' => 'This is a message', 'to' => ['27711234567'])
    end

    it 'sets correct status' do
      expect(rack_status).to eq(200)
    end

    it 'sets correct headers' do
      expect(rack_headers).to eq('Content-Type' => 'text/html')
    end

    it 'includes text in body' do
      expect(rack_body).to include('This is a message')
    end

    it 'includes to in body' do
      expect(rack_body).to include('27711234567')
    end
  end

  describe 'render multiple recipients and messages' do
    before :each do
      messages.push('text' => 'message 2', 'to' => ['27711234567'])
      messages.push('text' => 'message 1', 'to' => ['27711234567', '27711234588'])
    end

    it 'sets correct status' do
      expect(rack_status).to eq(200)
    end

    it 'sets correct headers' do
      expect(rack_headers).to eq('Content-Type' => 'text/html')
    end

    it 'includes text in body' do
      expect(rack_body).to include('message 1')
      expect(rack_body).to include('message 2')
    end

    it 'includes to in body' do
      expect(rack_body).to include('27711234567')

    end
  end
end
