require 'rails_helper'

RSpec.describe ProductSearch, type: :model do
  let!(:cached_product_search){ ProductSearch.create(cached_at: Date.current, query: 'iphone') }
  let!(:expired_product_search){ ProductSearch.create(cached_at: 2.months.ago, query: 'android') }
  
  describe 'self#popular_searches' do
    it 'should find recently cached searches' do
      expect(ProductSearch.popular_searches).to include(cached_product_search)
    end
  end

  describe 'self#cached_result_for' do
    it 'should return valid cache searches for that query' do
      expect(ProductSearch.cached_result_for('iphone').id).to eq cached_product_search.id
    end
  end

  describe '#cache_expiration_date' do
    it 'should provide a date that is 7 days in the future from the cache date' do
      expect(cached_product_search.cache_expiration_date).to eq(cached_product_search.cached_at + 7.days)
    end
  end

  describe "#reset_cache" do
    let!(:result){ Result.create(product_search_id: expired_product_search.id) }

    it 'should set the cached_at to now' do
      expect{
        expired_product_search.reset_cache
      }
      .to change(expired_product_search, :cached_at)
      .to(Date.current)
    end

    it 'should remove all associated results' do
      expired_product_search.reset_cache
      expect(expired_product_search.reload.results).to eq ([])
    end
  end

end
