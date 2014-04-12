require 'mystery_shopper'

require 'minitest/spec'
require 'minitest/autorun'

describe MysteryShopper::Listing do
	describe "parse" do
		before do
			f = File.open("../example_html/hd_listing_test.html")
			@listing = Nokogiri::HTML(f)
		end

		context "valid records" do
			before do
				
			end

			it "parses multiple records" do
			end

			it "returns limited records" do
			end
		end


		context "missing required field" do
			before do
			end

			it "returns no records" do
			end
		end

		context "no records found" do
			before do
			end
			
			it "returns no records" do
			end
		end
	end
end