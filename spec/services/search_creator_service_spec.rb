require 'rails_helper'

RSpec.describe SearchCreatorService do

  #TODO refactor this to read from flat file
  let(:product_data){
    {"features"=>{"Cellular Network Technology"=>"GSM", "Operating System"=>"Apple iOS", "Cell Phone Service Provider"=>"Unlocked", "Talk Time"=>"24 hours", "Has Bluetooth"=>"Y", "Mobile Operating System"=>"Apple iOS", "Number of Megapixels"=>"8 Megapixel", "Features"=>"Music Player, Full Web Browsers, GPS, Bluetooth, Dual Band, Camera, Wi-fi Ready", "Screen Size"=>"5.5 in", "blob"=>"MP3/WAV player; Siri; Voice over LTE", "Front-Facing Camera Megapixels"=>"1.2 Megapixels", "Battery Life"=>"384 hours", "Assembled Product Dimensions (L x W x H)"=>"6.22 x 3.06 x 0.28 Inches", "Cell Phone Type"=>"Certified Pre-Owned Phones", "Has Flash"=>"Y", "Condition"=>"Refurbished", "Rear-Facing Camera Megapixels"=>"8 Megapixels", "Connector Type"=>"1 x Apple Lightning Connector, 1 x Headphone", "Standby Time"=>"100 Hours", "Has Touchscreen"=>"Y", "Contained Battery Type"=>"Lithium Ion"}, "variation_id"=>"12iCE7Fhh0SmSMMAoc4ooE", "price"=>"679.99", "description"=>"Built on 64-bit desktop-class architecture, the ne... (visit site URLs for full description)", "height"=>"77.72", "updated_at"=>1487343686, "color"=>"Gold", "length"=>"157.99", "images_total"=>1, "images"=>["http://sem3-idn.s3-website-us-east-1.amazonaws.com/04a29350c86afe88b40fd34dc440e0d9,0.jpg"], "created_at"=>1472601925, "category"=>"Unlocked Phones", "weight"=>"172365.10", "manufacturer"=>"Apple", "sem3_id"=>"42tf6maIeuWw0q00McIcQO", "sitedetails"=>[{"latestoffers"=>[], "sku"=>"49230896", "recentoffers_count"=>0, "url"=>"http://www.walmart.com/ip/49230896", "name"=>"walmart.com", "listprice_currency"=>"USD", "listprice"=>"699.00"}, {"name"=>"amazon.com", "url"=>"http://www.amazon.com/dp/B00VIQA2GC", "latestoffers"=>[{"price"=>"679.99", "condition"=>"New", "id"=>"5Z27w2ibIGouWwiua0CkQW", "lastrecorded_at"=>1479203100, "seller"=>"BREED", "firstrecorded_at"=>1479203100, "availability"=>"Available [BBX: Buy Box][APR: Shipping with Amazon Prime]", "currency"=>"USD", "isactive"=>1}, {"seller"=>"BREED", "firstrecorded_at"=>1477681300, "currency"=>"USD", "availability"=>"Available [BBX: Buy Box][APR: Shipping with Amazon Prime]", "price"=>"799.99", "condition"=>"New", "id"=>"2xTKlfDtCqwqco6ckA0Msu", "lastrecorded_at"=>1477681300, "isactive"=>0}], "recentoffers_count"=>1, "sku"=>"B00VIQA2GC"}], "mpn"=>"IPH6P128GBGLD", "name"=>"Refurbished Apple iPhone 6 Plus 128GB GSM Smartphone (Unlocked)", "brand"=>"Iphone", "cat_id"=>"9359", "model"=>"IPH6P 128GB GOLD, iPhone 6 Plus", "width"=>"7.11", "geo"=>["usa"], "price_currency"=>"USD", "messages"=>[], "gtins"=>[]} 
  }

  let(:search_creator_service){ SearchCreatorService.new('iphone') }

  context 'when a product_search exists for that query' do
    let!(:expired_search){ ProductSearch.create(query: 'iphone', cached_at: 3.months.ago ) }

    it 'refreshes the cache date for that query' do
      search_creator_service.perform
      expect(expired_search.reload.cached_at).to eq Date.current
    end
  end

  context 'when no product search exists for that query' do
    it 'creates a new product search for the query string' do
      search_creator_service.perform
      product_search = ProductSearch.first
      expect(product_search.query).to eq 'iphone'
    end

    it 'creates a proper record for a result' do
      first_result = search_creator_service.perform.results.first

      expect(first_result.description).to eq product_data['description']
      expect(first_result.features).to eq product_data['features']
      expect(first_result.site_details).to eq product_data['sitedetails']
      expect(first_result.price).to eq product_data['price'].to_f
      expect(first_result.image_url).to eq product_data['images'].first
    end
  end

end