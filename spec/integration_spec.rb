require 'spec_helper'

require 'rack/test'

# test rack class
class TestRack
  def call(env)
    return [404, {}, []]
  end
end

describe 'Integration' do
  include Rack::Test::Methods

  def app
    @middleware
  end

  def post_json(uri, json)
    post(uri, json, { "CONTENT_TYPE" => "application/json" })
  end

  before :each do
    @test_rack = TestRack.new
    @middleware = Clickatell::Sandbox::Rack::Middleware.new(@test_rack)
  end

  it 'return 404' do
    get '/'
    expect(last_response.status).to eq(404)
  end

  describe '/rest/message' do
    context 'successfull message'do
      it 'returns 200' do
        post_json '/rest/message', { text: 'This is a message', to: ['27711234567'] }
        expect(last_response).to be_ok
      end
    end
  end
end