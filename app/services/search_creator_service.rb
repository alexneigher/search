require 'semantics3'

class SearchCreatorService

  def initialize(query)
    @query = query
  end

  def perform
    sem3.products_field( "search", @query )
    data = sem3.get_products()
    ProductSearch.create(query: @query)
  end

  private

    def sem3
      @sem3 ||= Semantics3::Products.new(ENV['SEMANTICS_KEY'],ENV['SEMANTICS_SECRET'])
    end

end