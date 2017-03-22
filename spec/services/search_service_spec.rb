require 'rails_helper'

RSpec.describe SearchService do
  let(:search_params){
    {
      query: 'iPhone'
    }
  }

  let(:search_service){ SearchService.new(search_params) }

  it 'downcases the search query' do
    expect(search_service.search_query).to eq 'iphone'
  end


  context 'when cached results are present and less than 7 days old' do
    let(:cached_product_search){ ProductSearch.create(cached_at: Date.current, query: 'iphone')}
    let!(:cached_result){ cached_product_search.results.create(description: 'short desc') }
    
    it 'find the cached version' do
      expect(search_service.results).to include(cached_result)
    end
  end

  context 'when no cached results are present' do
    it 'creates a new product search' do
      expect_any_instance_of(SearchCreatorService).to receive(:perform)
      search_service.results
    end
  end

  context 'when the cache is older than 7 days' do
    let!(:expired_product_search){ ProductSearch.create(cached_at: 3.months.ago, query: 'iphone') }
    
    it 're saturates the old search' do
      expect_any_instance_of(SearchCreatorService).to receive(:perform)
      search_service.results
    end
  end


end
