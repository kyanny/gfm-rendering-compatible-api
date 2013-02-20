require 'spec_helper'

describe 'GFM API App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "GET / renders HTML" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to match(/<!DOCTYPE html>/)
  end

  it "POST /markdown returns HTML" do
    post '/markdown', '{"text":"**cool**"}'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('<p><strong>cool</strong></p>')
  end

  context "When request includes code snippet" do
    it "should return highlighted code snippet" do
      post '/markdown', '{"text":"```ruby\nputs \"Hello world\"\n```"}'
      expect(last_response).to be_ok
      expect(last_response.body).to match(/<div class="highlight">/)
    end
  end

  it "The response of POST /markdown includes Access-Control-Allow-Origin header" do
    post '/markdown', '{"text":"**cool**"}'
    expect(last_response.headers).to include("Access-Control-Allow-Origin" => "*")
  end

  it "POST /markdown/raw returns HTML" do
    post '/markdown/raw', '**cool**'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('<p><strong>cool</strong></p>')
  end

  context "When request includes code snippet" do
    it "should return highlighted code snippet" do
      post '/markdown/raw', "```ruby\nputs \"Hello world\"\n```"
      expect(last_response).to be_ok
      expect(last_response.body).to match(/<div class="highlight">/)
    end
  end

  it "The response of POST /markdown/raw includes Access-Control-Allow-Origin header" do
    post '/markdown/raw', '**cool**'
    expect(last_response.headers).to include("Access-Control-Allow-Origin" => "*")
  end
end
