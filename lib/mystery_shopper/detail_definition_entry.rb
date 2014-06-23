require "nokogiri"

module MysteryShopper
	class DetailDefinitionEntry
		attr_accessor :name, :identifier, :data_type, :attribute, :must_be_present

		def initialize(name, details)
			@name = name

			self.extract_definition(details)
		end

		def extract_definition(details)
			# TODO: Throw exeception if no identifier is defined
			raise ArgumentError.new("no 'identifier' defined") if !details[:identifier]
			@identifier = details[:identifier]

			# TODO Convert data type to class
			@data_type = !details[:data_type].nil? ? Object.const_get(details[:data_type]) : String
			@attribute = details[:attr] ? details[:attr].to_s : 'content'
			@must_be_present = details[:must_be_present] == true
		end

		def get_value(content)
			element = Nokogiri::HTML(content).at_css(@identifier)
			if element.nil?
				return @must_be_present ? raise(NameError, "Element '#{@identifier}' could not be found.") : nil
			end
				
			value = @attribute == 'content' ? element.inner_html : element.attr(@attribute)
			if value.nil? || value.strip.empty?
				return @must_be_present ? raise(NameError, "Value for '#{@identifier}' '#{@attribute}' could not be found.") : nil
			end

			value
		end
	end
end