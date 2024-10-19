require 'active_record'
require './models/user.rb'
class Admin < ActiveRecord::Base
  include Userable
end