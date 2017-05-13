require 'json'
require 'sinatra'
require 'sinatra/activerecord'

# Load Models
Dir["./app/models/*.rb"].each {|file| require file }

require './config/database'

class App < Sinatra::Base
  get '/' do
    'Hello world!'
  end
end
