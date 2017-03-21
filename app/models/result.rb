class Result < ApplicationRecord
  belongs_to :product_search


  def remote_url
    # TODO this is "incorrect" as there are many listings for this product
    # But, grab a single one for now
    site_details.first['url']
  end
end
