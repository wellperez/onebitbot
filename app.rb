require 'json'
require 'sinatra'
require 'sinatra/activerecord'

# Load Models
Dir["./app/models/*.rb"].each {|file| require file }

require './config/database'

class App < Sinatra::Base
  get '/sinatra' do
    'Hello world Sinatra!'
  end
end
