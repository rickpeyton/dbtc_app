class Chain < ActiveRecord::Base
  belongs_to :user
  has_many :links
  validates_presence_of :name, :user_id

  def current_chain
    chain = 0
    while links.find_by(link_day: Time.now.utc.midnight.yesterday - (chain * 86400)) != nil
      chain += 1
    end
    chain += 1 if links.find_by(link_day: Time.now.utc.midnight) != nil
    compare_to_longest_chain(chain)
    chain
  end

  def compare_to_longest_chain(current_chain)
    if longest_chain == nil || current_chain > longest_chain
      update_attribute(:longest_chain, current_chain)
    end
  end
end
