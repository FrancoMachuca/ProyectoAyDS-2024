require 'active_record'
class Level < ActiveRecord::Base

    has_and_belongs_to_many :users
    has_many :questions
end
