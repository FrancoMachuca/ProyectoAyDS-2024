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
post '/registro' do
    user = User.new(params[:user][:password])
    user.save
    redirect '/login'
end
post '/login' do
    user = User.find_by(email: params[:user][:email])
    if user && user.password == params[:user][:password]
        session[:user_id] = user.id
        redirect '/home'
        else
            redirect '/login'
            end
end 



