module MysteryShopper
	class Listing
		@@definition_key = :listing

		def initialize(source)
			# Retrieve the listing scraping template from emmory
		end

		def parse(content)
			list = Nokogiri::HTML(content)
		end

		def parse_record(content)
			record = Nokogiri::HTML(content)
		end

		protected
		def load_definition
			@listing_definition 
		end

		def load_products(product_urls)
			# Perform a mass loading of product pages
		end
	end
end
