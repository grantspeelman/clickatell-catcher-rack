require 'spec_helper'

require 'rack/test'

# test rack class
class TestRack
  attr_accessor :status, :headers, :body, :client_id

  def initialize
    @status = 200
    @headers = { 'Content-Type' => 'text/html' }
    @body = ['Text Here']
    @env_block = nil
  end

  def env(&block)
    @env_block = block
  end

  def call(env)
    @env_block.call(env) if @env_block
    [@status, @headers, @body]
  end
end

describe 'Integration' do
  include Rack::Test::Methods

  def app
    @middleware
  end

  before :each do
    @test_rack = TestRack.new
    @middleware = Clickatell::Sandbox::Rack::Middleware.new(@test_rack)
  end

  it 'return 200' do
    @test_rack.status = 200
    get '/'
    expect(last_response).to be_ok
  end
end