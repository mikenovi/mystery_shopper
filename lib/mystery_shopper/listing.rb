module MysteryShopper
	class Listing
		@@product_listing_definition_key = :product_listing
		@@product_preview_definition_key = :product_preview

		def initialize(source)
			# Retrieve the listing scraping template from memory
			@source = source
			self.load_definition
		end

		def parse(content)
			products_list = Nokogiri::HTML(content).css(@product_list_definition)
			products_list.map { |p| parse_preview p.content() }
		end

		def parse_preview(content)
			begin
				return ProductPreview.new(MysteryShopper::Configuration.config.send(@source).send(@@product_preview_definition_key)).parse(content)
			rescue NameError
				return nil
			end
		end

		protected
		def load_definition
			@product_list_definition = MysteryShopper::Configuration.config.send(@source).send(@@product_listing_definition_key)
		end
	end
end
