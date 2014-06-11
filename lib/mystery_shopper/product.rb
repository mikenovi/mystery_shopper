module MysteryShopper
	class Product < Item
		@@definition_key = :product

		def initialize(source)
			@source = source
			self.load_definition(MysteryShopper::Configuration.config.send(@source).send(@@definition_key))
		end
	end
end