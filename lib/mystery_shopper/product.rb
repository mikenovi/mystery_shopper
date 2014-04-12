module MysteryShopper
	class Product
		@@definition_key = :product

		def initialize(source)
			@source = source
			self.load_definition
		end

		def parse(content)
		end

		protected
		def load_definition
			# TODO: Exceptions if the definition does not exist
			# !MysteryShopper.config.sources[source]
			# !MysteryShopper.config.sources[source][@@definition_key]

			@definition = []
			MysteryShopper.config.sources[source][@@definition_key].each do |key, details|
				@definition << DetailDefinitionEntry.new key, details
			end				
		end
	end
end