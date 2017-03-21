class ProductSearch < ApplicationRecord
  has_many :results, dependent: :destroy

  scope :recently_cached, -> { where('cached_at >= ?', 7.days.ago) }
  scope :cache_expired, -> { where('cached_at < ?', 7.days.ago) }

  validates_uniqueness_of :query #only one search per term (will either be fresh or expired)

  def self.cached_result_for(query)
    recently_cached.find_by(query: query)
  end

  def self.expired_result_for(query)
    cache_expired.find_by(query: query)
  end
end
