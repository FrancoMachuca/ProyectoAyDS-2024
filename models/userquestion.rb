require 'active_record'
class UserQuestion < ActiveRecord::Base
    belongs_to :user
    belongs_to :question
end
