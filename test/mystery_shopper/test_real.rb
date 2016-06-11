require 'common_helpers'

describe MysteryShopper::Search do
  describe "Lowes" do
    before do
      MysteryShopper::Configuration.configure do |config|
        config.lowes.search_url = "http://www.lowes.com/search?searchTerm=%%search_term%%"
        config.lowes.curl_options = { cookie: "sn=2313" }
        #, proxy: "http://proxy-us1.vpnsecure.me:8080", :proxyuserpwd => "#{ENV['VPN_SECURE_USERNAME']}:#{ENV['VPN_SECURE_PASSWORD']}" }
        config.lowes.product_listing = "ul > li.product-wrapper"
        config.lowes.product_preview = { 
          :name => { :identifier => "p.product-title", :must_be_present => true, :value_transform => lambda { |value| value.strip } },
          :detail_url => { :identifier => "a", :attr => "href", :must_be_present => true, :value_transform => lambda { |value| "http://www.lowes.com#{value}" } },
          :image_url => { :identifier => "img.product-image", :attr => "data-src" },
          :price => { :identifier => "span.js-price" },
        }
        config.lowes.product = {
          :name => { :identifier => "div.pd-title > h1", :must_be_present => true, :value_transform => lambda { |value| value.strip }},
          :price => { :identifier => "span[itemprop='price']", :attr => "content"},
          :image_url => { :identifier => "img.product-image", :attr => "src" },
          :specifications => { :identifier => "div#collapseSpecs", :data_type => :key_value, :key => 'tr > th', :value => 'tr > td > span' },
          :description => { :identifier => "div#collapseDesc", :value_transform => lambda { |value| 
            content = Nokogiri::HTML(value)
            paragraph = content.at_css('p') ? content.at_css('p').text().strip + "\n\n" : ""
            list = content.css('li').map { |li| " * #{li.text().strip}" }.join("\n")
            paragraph + list
            } 
          }
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
      skip "must reimplement Home Depot reader"
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