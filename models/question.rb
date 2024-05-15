require 'active_record'
class Question < ActiveRecord::Base
    self.primary_key = 'id_question'
end