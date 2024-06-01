require 'active_record'
class Answer < ActiveRecord::Base
    belongs_to :questions
        
end
