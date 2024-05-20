require 'active_record'
class Level < ActiveRecord::Base
    self.abstract_class = true

    has_many :users_levels
    has_many :users, through: :users_levels

    has_many :questions
end
