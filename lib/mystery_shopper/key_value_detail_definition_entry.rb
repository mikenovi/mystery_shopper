require 'nokogiri'

module MysteryShopper
	class KeyValueDetailDefinitionEntry < DetailDefinitionEntry
		attr_accessor :key_definition, :value_definition

		def initialize(name, details)
			super(name, details)
		end

		def extract_key_value_definition(details)
			raise ArgumentError.new("no 'key' defined") if !details[:key]
			raise ArgumentError.new("no 'value' defined") if !details[:value]
			
			@key_definition = details[:key]
			@value_definition = details[:value]
		end

		def get_value(content)
			content = super(content)

			# TODO
		end
	end
end