require 'sinatra'
require './models'

get '/' do
    redirect '/login'
end

get '/login' do
    File.read('login.html')

end
get '/registro' do
    File.read('registro.html')

end

post '/login/post' do


end 



