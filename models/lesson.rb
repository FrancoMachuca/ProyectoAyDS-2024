require 'active_record'
class Lesson < ActiveRecord::Base
    self.primary_key = 'id_lesson'
end