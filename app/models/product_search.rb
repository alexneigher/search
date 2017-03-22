class ProductSearch < ApplicationRecord
  has_many :results, dependent: :destroy

  scope :recently_cached, -> { where('cached_at >= ?', 7.days.ago) }
  scope :cache_expired, -> { where('cached_at < ?', 7.days.ago) }

  validates_uniqueness_of :query #only one search per term (will either be fresh or expired)

  def self.popular_searches
    #render the top 5 most recently cached results
    recently_cached.order(:cached_at).limit(5)
  end

  def self.cached_result_for(query)
    recently_cached.find_by(query: query)
  end

  def cache_expiration_date
    self.cached_at + 7.days
  end

end
