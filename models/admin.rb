# frozen_string_literal: true

require 'active_record'
require './models/user'
class Admin < ActiveRecord::Base
  include Userable
end
