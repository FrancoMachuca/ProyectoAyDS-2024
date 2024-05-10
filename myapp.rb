require 'sinatra'

get '/' do
    redirect '/login'
end

get '/login' do
    File.read('index.html')

end

post '/login/post' do


end 



