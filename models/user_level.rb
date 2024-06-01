require 'active_record'
class UserLevel < ActiveRecord::Base
    self.table_name = 'users_levels'

    belongs_to :user
    belongs_to :level

    def increaseScore
    end
        
end
