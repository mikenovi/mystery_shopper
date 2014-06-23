require 'common_helpers'

describe MysteryShopper::Product do
	before do
		MysteryShopper::Configuration.configure do |config|
			config.test_source.product_listing = "Product Listing"
      config.test_source.product_preview = "Product Preview"
      config.test_source.product = "Product"
		end

		MysteryShopper::Product.any_instance.expects(:load_definition).with(MysteryShopper::Configuration.config.test_source.product).once
	end

	describe "load" do
		before do
			@product = MysteryShopper::Product.new :test_source
			@url = "http://www.example.com"
		end

		it "throws an exception if HTTP request times out" do
			response = Typhoeus::Response.new(code: 0)
			response.expects(:timed_out?).once.returns(true)
			Typhoeus.stub('http://www.example.com').and_return(response)

			err = ->{ @product.load @url }.must_raise IOError
			err.message.must_equal "request timed out"
		end

		it "throws an exception if there is no HTTP response" do
			response = Typhoeus::Response.new(code: 0)
			Typhoeus.stub('http://www.example.com').and_return(response)
			
			err = ->{ @product.load @url }.must_raise IOError
			err.message.must_equal "no HTTP response"
		end

		it "throws an exception if HTTP response is an error" do
			response = Typhoeus::Response.new(code: 404)
			Typhoeus.stub('http://www.example.com').and_return(response)
			
			err = ->{ @product.load @url }.must_raise IOError
			err.message.must_equal "failed HTTP request with response 404"
		end

		it "parses the response on successful request" do
			product_response_body = "Product to parse"
			response = Typhoeus::Response.new(code: 200, body: product_response_body)
			Typhoeus.stub('http://www.example.com').and_return(response)

			@product.expects(:parse).with(product_response_body).once
			@product.load @url
		end
	end

	describe "initialize" do
		it "parses definition for source" do
			MysteryShopper::Product.new :test_source
		end

		it "does not call load if url is not defined" do
			MysteryShopper::Product.any_instance.expects(:load).never
			MysteryShopper::Product.new :test_source
		end

		it "calls load if url is provided" do
			MysteryShopper::Product.any_instance.expects(:load).with("http://www.example.com").once
			MysteryShopper::Product.new :test_source, "http://www.example.com"
		end
	end
end