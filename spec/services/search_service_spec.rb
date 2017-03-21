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

  context 'when no cached results are present' do
    it 'creates a new product search, and persists results' do
      expect_any_instance_of(SearchCreatorService).to receive(:perform)
      search_service.results
    end
  end

  context 'when the cache is older than 7 days' do
    xit 'creates a new product search, and persists results' do
      expect_any_instance_of(SearchCreatorService).to receive(:perform)
      search_service.results
    end
  end


end
