require 'semantics3'

class SearchCreatorService

  def initialize(query)
    @query = query
  end

  def perform
    sem3.products_field("search", @query)

    #guard against failed external call
    begin
      data = sem3.get_products()
    rescue => e
      #push to airbrake or other error service :)
      return 'No connection'
    end

    populate_product_search_and_results(data)
  end

  private

    def populate_product_search_and_results(data)
      api_results = data["results"]
      return [] unless api_results.present?

      # Wrap in transaction, so we dont wipe away old cache if error occurs
      product_search = ActiveRecord::Base.transaction do
                        product_search = create_or_refresh_product_search
                        populate_results(product_search, api_results)
                        return product_search
                       end

    end

    def create_or_refresh_product_search
      product_search = ProductSearch.find_by_query(@query)
      
      if product_search.present?
        #refresh existing
        product_search.update(cached_at: Date.current)
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