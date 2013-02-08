require 'sinatra'
require 'json'
require 'github/markdown'
require 'slim'

if ENV['RACK_ENV'] == 'production'
  require 'newrelic_rpm'
end

configure do
  Slim::Engine.set_default_options pretty: true
end

get '/' do
  @hostname = request.env['HTTP_HOST']
  slim :index
end

post '/markdown' do
  json_data = JSON.parse(request.env['rack.input'].read)
  GitHub::Markdown.render json_data['text']
end

post '/markdown/raw' do
  GitHub::Markdown.render request.env['rack.input'].read
end
