require 'common_helpers'

describe MysteryShopper::Listing do
	describe "parse" do
		before do
			MysteryShopper::Listing.stub_any_instance :load_definition, nil do
				@listing = MysteryShopper::Listing.new(:test)
			end
			
			@doc = "<ul><li class='product unique'>Product 1</li><li class='product'>Product 2</li><li class='product'>Product 3</li></ul>"
		end
	
		it "parses no records" do
			@listing.instance_variable_set :@product_list_definition, 'li.no_product'
			
			@listing.stub :parse_preview, "Product Preview" do
			 	@listing.parse(@doc).count.must_equal 0
			end
		end

		it "parses one records" do
			@listing.instance_variable_set :@product_list_definition, 'li.unique'

			@listing.stub :parse_preview, "Product Preview" do
			 	@listing.parse(@doc).count.must_equal 1
			end
		end

		it "returns multiple records" do
			@listing.instance_variable_set :@product_list_definition, 'li.product'

			@listing.stub :parse_preview, "Product Preview" do
			 	@listing.parse(@doc).count.must_equal 3
			end
		end
	end

	describe "parse_preview" do
		before do
			@product_preview_definition = { 
				:name => { :identifier => "a#name", :must_be_present => true },
				:detail_url => { :identifier => "a#name", :attr => "href", :must_be_present => true },
				:image_url => { :identifier => "img", :attr => "src" },
				:price => { :identifier => "div#price" },
			}

			MysteryShopper::Configuration.configure do |config|
				config.test_source.product_preview = @product_preview_definition
			end

			@content = %Q{
        <a id="name" href="http://example.com">Turbo Test</a>
        <img id="main" src="http://example.com/test.png" />
        <div id="price">3.50</div>
      }
		end

		it "calls new with product preview definition" do
			MysteryShopper::ProductPreview.stubs(:new).with(@product_preview_definition).once
			@listing = MysteryShopper::Listing.new(:test_source)
			@listing.send(:parse_preview, @content)
		end

		it "calls parse for an instance" do
			MysteryShopper::ProductPreview.any_instance.stubs(:parse).with(@content).once
			@listing = MysteryShopper::Listing.new(:test_source)
			@listing.send(:parse_preview, @content)
		end

		it "returns nil if parse fails" do
			MysteryShopper::ProductPreview.any_instance.stubs(:parse).with(@content).once.raises(NameError, "test parse error")
			@listing = MysteryShopper::Listing.new(:test_source)
			@listing.send(:parse_preview, @content).must_be_nil
		end
	end
end