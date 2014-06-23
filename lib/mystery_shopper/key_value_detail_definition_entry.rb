require 'nokogiri'

module MysteryShopper
	class KeyValueDetailDefinitionEntry < DetailDefinitionEntry
		attr_accessor :key_definition, :value_definition

		def initialize(name, details)
			super(name, details)

			self.extract_key_value_definition(details)
		end

		def get_value(content)
			elements = Nokogiri::HTML(super(content))

			keys   = elements.css(@key_definition).map(&:content)
			values = elements.css(@value_definition).map(&:content)

			raise ArgumentError.new "unequal number of keys and values" unless  keys.count == values.count
			Hash[keys.zip(values)]
		end

		protected
		def extract_key_value_definition(details)
			raise ArgumentError.new("no 'key' defined") if !details[:key]
			raise ArgumentError.new("no 'value' defined") if !details[:value]
			
			@key_definition = details[:key]
			@value_definition = details[:value]
		end
	end
end