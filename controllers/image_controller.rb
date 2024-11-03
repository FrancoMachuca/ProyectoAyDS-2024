# frozen_string_literal: true

require '.\models\user'
require '.\models\image'
# Esta clase se encarga de manejar los eventos relacionados
# a las fotos que sube el usuario.
class ImageController < Sinatra::Base
  def set_image(img: Image, user: User)
    unless user.image.nil?
      i = user.image
      user.image = nil
      user.save!
    end
    replace_image(new: img, old: i, user: user)
  end

  def replace_image(new: Image, old: Image, user: User)
    user.image = new
    new.save!
    user.save!
    safe_delete_img(img: old)
  rescue StandardError => e # Si la imagen nueva no se guarda correctamente,
    # o si la anterior no se borra de la base de datos, se restaura la anterior.
    user.image = old
    user.save
    puts e.message
  end

  def safe_delete_img(img: Image)
    default_pic = Image.first
    return if img.nil? || img == default_pic

    img.remove_image!
    Image.delete(img)
  end

  set :views, File.expand_path('../views', __dir__)
  get '/actualizarFoto' do
    if session[:user_id]
      erb :upload_image
    else
      redirect '/login'
    end
  end

  post '/actualizarFoto' do
    if session[:user_id]
      img = Image.new
      user = User.find(session[:user_id])
      img.image = params[:file] # carrierwave sube el archivo automáticamente.
      img.caption = 'Profile Pic' # Se puede recibir otro con params.
      # Se pueden agregar más restricciones
      set_image(img: img, user: user) if !img.nil? && !img.image.nil? && img.valid?
    end
    redirect '/perfil'
  end
end
