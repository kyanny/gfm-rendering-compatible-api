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

  it "POST /markdown/raw returns HTML" do
    post '/markdown/raw', '**cool**'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('<p><strong>cool</strong></p>')
  end
end
