require 'spec_helper'

require 'rack/test'

# test rack class
class TestRack
  def call(_env)
    [404, {}, []]
  end
end

describe 'Integration' do
  include Rack::Test::Methods

  def app
    @middleware
  end

  def post_json(uri, body)
    post(uri, MultiJson.dump(body), 'CONTENT_TYPE' => 'application/json')
  end

  # @return [Hash]
  def parsed_last_response
    MultiJson.load(last_response.body)
  end

  before :each do
    @test_rack = TestRack.new
    @middleware = Clickatell::Sandbox::Rack::Middleware.new(@test_rack)
  end

  it 'return 404' do
    get '/'
    expect(last_response.status).to eq(404)
  end

  describe 'POST /rest/message' do
    context 'successfull message' do
      before :each do
        post_json '/rest/message', 'text' => 'This is a message', 'to' => ['27711234567']
      end

      it 'returns 200' do
        expect(last_response).to be_ok
      end

      it 'adds the message' do
        expect(@middleware.messages).to contain_exactly(
          'text' => 'This is a message', 'to' => ['27711234567']
        )
      end

      it 'has accepted body' do
        expect(parsed_last_response).to eq('data' => { 'message' => [
                                             { 'accepted' => true,
                                               'to' => '27711234567',
                                               'apiMessageId' => '1' }
                                           ] })
      end

      it 'is application/json' do
        expect(last_response.headers['Content-Type']).to eq('application/json')
      end
    end
  end
end
