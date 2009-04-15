require 'rubygems'
require 'sinatra'
require 'dm-core'

class Url
  include DataMapper::Resource
  property :id,   Integer, :serial => true
  property :url,  String
  property :code, String
end

configure do
  BASE = 36
  DataMapper::Logger.new(STDOUT, 0)
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/tiny.sqlite3")
  DataMapper.auto_upgrade!
end

post '/new' do
  @new = Url.new(:url => params[:url])
  if @new.save
    redirect "/new/#{@new.id.to_s(BASE)}"
  else
    erb :index
  end
end

get '/new/:code' do
  erb :new
end

get '/:code' do
  url = Url.get(params[:code].to_i(BASE))
  redirect url.nil? ? '/' : url.url
end

get '/' do
  erb :index
end