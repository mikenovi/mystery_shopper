require 'common_helpers'

describe MysteryShopper::Search do
  describe "Lowes" do
    before do
      MysteryShopper::Configuration.configure do |config|
        config.lowes.search_url = "http://www.lowes.com/Search=%%search_term%%?storeId=10151&langId=-1&catalogId=10051&N=0&Ntt=%%search_term%%#!&rpp=10&page=%%page%%"
        config.lowes.curl_options = { cookie: "selectedStore1=Lowe's Of S Durham## NC|2778|0|27713|no|Y|4402 Fayetteville Road|Durham|Mon-Sat 6 Am - 10 Pm## Sun 8 Am - 8 Pm|(919) 206-4800|(919) 206-4801|KE" }
        config.lowes.product_listing = "ul#productResults > li"
        config.lowes.product_preview = { 
          :name => { :identifier => "h3.productTitle > a", :must_be_present => true },
          :detail_url => { :identifier => "h3.productTitle > a", :attr => "href", :must_be_present => true, :value_transform => lambda { |value| "http://www.lowes.com#{value}" } },
          :image_url => { :identifier => "img.productImg", :attr => "src" },
          :price => { :identifier => "p.pricing strong" },
        }
        config.lowes.product = {
          :name => { :identifier => "div#descCont > div.itemInfo > h1", :must_be_present => true},
          :price => { :identifier => "div#descCont div.pricingDetails div#pricing span.price"},
          :image_url => { :identifier => "div#imgCont img#prodPrimaryImg", :attr => "src" },
          :specifications => { :identifier => "div#specifications-tab", :data_type => :key_value, :key => 'td:nth-child(odd)', :value => 'td:nth-child(even)' },
          :description => { :identifier => "div#description-tab" }
        }
      end
    end

    it "gets a list of preview items" do
      s = MysteryShopper::Search.new(:lowes)
      results = s.perform_search("husqvarna chainsaw")

      results.count.must_be :>, 0
      results.each do |r|
        r.name.wont_be_nil
        r.detail_url.wont_be_nil
        r.image_url.wont_be_nil
        r.price.wont_be_nil
      end
    end

    it "retrieves product details" do
      s = MysteryShopper::Search.new(:lowes)
      results = s.perform_search("husqvarna chainsaw")
      results.count.must_be :>, 0
      
      p = MysteryShopper::Product.new(:lowes, results[0].detail_url)
      p.name.wont_be_nil
      p.price.wont_be_nil
      p.image_url.wont_be_nil
      p.specifications.must_be_instance_of Hash
      p.specifications.count.must_be :>, 0
      p.description.wont_be_nil
    end
  end

  describe "Home Depot" do
    before do
      MysteryShopper::Configuration.configure do |config|
        config.homedepot.search_url = "http://www.homedepot.com/s/%%search_term%%"
        config.homedepot.product_listing = "div#products > div.product"
        config.homedepot.product_preview = { 
          :name => { :identifier => "a.item_description", :must_be_present => true },
          :detail_url => { :identifier => "a.item_description", :attr => "href", :must_be_present => true },
          :image_url => { :identifier => "div.content_image img", :attr => "src" },
          :price => { :identifier => "span.item_price" },
        }
        config.homedepot.product = {
          :name => { :identifier => "h1.product_title", :must_be_present => true},
          :price => { :identifier => "span#ajaxPrice"},
          :image_url => { :identifier => "div#popup-enlarge-image img", :attr => "src" },
          :specifications => { :identifier => "div#specifications", :data_type => :key_value, :key => 'td:nth-child(odd)', :value => 'td:nth-child(even)' },
          :description => { :identifier => "div.main_description" }
        }
      end
    end

    it "gets a list of preview items" do
      s = MysteryShopper::Search.new(:homedepot)
      results = s.perform_search("dewalt hammer drill")

      results.count.must_be :>, 0
      results.each do |r|
        r.name.wont_be_nil
        r.detail_url.wont_be_nil
        r.image_url.wont_be_nil
        r.price.wont_be_nil
      end
    end

    it "retrieves product details" do
      s = MysteryShopper::Search.new(:homedepot)
      results = s.perform_search("dewalt hammer drill")
      results.count.must_be :>, 0
      
      p = MysteryShopper::Product.new(:homedepot, results[0].detail_url)
      p.name.wont_be_nil
      p.price.wont_be_nil
      p.image_url.wont_be_nil
      p.specifications.must_be_instance_of Hash
      p.specifications.count.must_be :>, 0
      p.description.wont_be_nil
    end
  end
end