require 'active_record'
require '.\models\user.rb'
class Ranking < ActiveRecord::Base
    include Singleton
    belongs_to :user
    belongs_to :level

    def getTotalScoreOf(user: User)
        Ranking.find_all(user.user_id).sum('userLevelScore')
    end

    def getLevelsCompleted(user: User)
        Ranking.count(:conditions => "userLevelScore > 0")
    end
end