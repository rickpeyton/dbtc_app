class Link < ActiveRecord::Base
  belongs_to :chain
  validates_presence_of :chain_id, :link_day
  validates_uniqueness_of :link_day, scope: :chain_id
end
