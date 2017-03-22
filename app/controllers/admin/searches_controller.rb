module Admin
  class SearchesController < ApplicationController
    layout 'admin'

    def index
      @cached_product_searches = ProductSearch.includes(:results).recently_cached
      @expired_product_searches = ProductSearch.includes(:results).cache_expired
    end

  end

end