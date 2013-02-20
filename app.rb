# coding: utf-8
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
  headers "Access-Control-Allow-Origin" => "*"
  json_data = JSON.parse(request.body.read)
  text = GitHub::Markdown.render(json_data['text']).chomp
  syntax_highlight(text)
end

post '/markdown/raw' do
  headers "Access-Control-Allow-Origin" => "*"
  text = GitHub::Markdown.render(request.body.read).chomp
  syntax_highlight(text)
end

helpers do
  require 'pygments.rb'
  require 'nokogiri'

  def syntax_highlight(body)
    doc = Nokogiri::HTML.fragment(body)
    doc.xpath("pre[@lang]").each do |pre|
      code  = pre.css("code")[0]
      lexer = pre[:lang]
      begin
        pre.replace Pygments.highlight(
          code.text.rstrip,
          :lexer   => lexer,
          :options => { :encoding => 'utf-8' }
        ) if code
      rescue MentosError
        next
      end
    end
    doc.to_s
  end
end
