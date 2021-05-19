class User < ApplicationRecord
    has_many :outbound_nominations, :class_name => 'Nomination', :foreign_key => 'nominator_id'
    has_many :inbound_nominations, :class_name => 'Nomination', :foreign_key => 'nominated_id'
    has_one :work_preference
    
    # validates :github_id, uniqueness: { case_sensitive: false }


    def self.order_by_inbound_nominations(order)
        User.joins(:inbound_nominations).group("users.id").order("count(nominated_id) #{order}")
    end
    
    def find_nominated_users
        User.joins(:inbound_nominations).group("users.id").where("nominator_id = ? AND active = ?", self.id, true)
    end

    def find_co_worker_nominated_users
        User.joins(:inbound_nominations).group("users.id").where("nominator_id = ? AND active = ? AND co_worker = ?", self.id, true, true)
    end

    def find_past_co_worker_nominated_users
        User.joins(:inbound_nominations).group("users.id").where("nominator_id = ? AND active = ? AND co_worker = ?", self.id, true, false)
    end
end
