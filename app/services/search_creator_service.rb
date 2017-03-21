require 'semantics3'

class SearchCreatorService

  def initialize(query)
    @query = query
  end

  def perform
    sem3.products_field("search", @query)
    data = sem3.get_products()
    populate_product_search_and_results(data)
  end

  private

    def populate_product_search_and_results(data)
      api_results = data["results"]
      raise "API Error" unless api_results.present?

      product_search = ActiveRecord::Base.transaction do
                        product_search = create_or_refresh_product_search
                        populate_results(product_search, api_results)
                        return product_search
                       end

    end

    def create_or_refresh_product_search
      product_search = ProductSearch.expired_result_for(@query)
      
      if product_search.present?
        product_search.cached_at = Date.current
        product_search.results.destroy_all #TODO, can refactor into SQL "delete from results, where..."
      else
        #create a new one
        product_search = ProductSearch.create(query: @query, cached_at: Date.current)
      end

      return product_search
    end

    def populate_results(product_search, api_results)
      results = []

      api_results.each do |api_result|
        results << product_search
                    .results
                    .new(
                      description: api_result["description"],
                      features: api_result["features"],
                      site_details: api_result["sitedetails"],
                      price: api_result["price"],
                      image_url: api_result["images"].first
                    )
      end

      # batch create, avoids n+1 on INSERT
      # see https://github.com/zdennis/activerecord-import
      Result.import results
    end

    def sem3
      @sem3 ||= Semantics3::Products.new(ENV['SEMANTICS_KEY'], ENV['SEMANTICS_SECRET'])
    end

end