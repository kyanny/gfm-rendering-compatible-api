require 'sinatra'
require 'json'
require 'html/pipeline'
require 'slim'

if ENV['RACK_ENV'] == 'production'
  require 'newrelic_rpm'
end

def markdown_to_html(markdown)
  context = {
    asset_root: "http://assets.github.com/images/icons/",
    gfm: false
  }

  pipeline = HTML::Pipeline.new([
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SanitizationFilter,
      HTML::Pipeline::ImageMaxWidthFilter,
      HTML::Pipeline::HttpsFilter,
      HTML::Pipeline::MentionFilter,
      HTML::Pipeline::EmojiFilter,
    ], context)
  result = pipeline.call(markdown)[:output].to_s
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
  markdown_to_html(json_data['text'])
end

post '/markdown/raw' do
  markdown_to_html(request.env['rack.input'].read)
end
