module MysteryShopper
	class Product < Item
		@@definition_key = :product

		def initialize(source)
			@source = source
			self.load_definition
		end
	end
end