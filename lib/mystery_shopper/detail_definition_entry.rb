require "nokogiri"

module MysteryShopper
	class DetailDefinitionEntry
		attr_accessor :name, :identifier, :data_type, :attribute, :must_be_present, :value_transform

		def self.create(name, details)
			if !!details[:data_type] && details[:data_type].class.method_defined?(:to_s) && Object.const_defined?("::MysteryShopper::#{details[:data_type].to_s.split('_').map(&:capitalize).join}DetailDefinitionEntry")
				dde = Object.const_get("::MysteryShopper::#{details[:data_type].to_s.split('_').map(&:capitalize).join}DetailDefinitionEntry").new(name, details)
			else
				dde = DetailDefinitionEntry.new(name, details)
			end

			dde
		end

		def initialize(name, details)
			@name = name

			self.extract_definition(details)
		end

		def extract_definition(details)
			# Throw exeception if no identifier is defined
			raise ArgumentError.new("no 'identifier' defined") if !details[:identifier]
			@identifier = details[:identifier]

			# Convert data type to class
			@data_type = (!!details[:data_type] && details[:data_type].is_a?(Class)) ? details[:data_type] : String
			@attribute = !!details[:attr] ? details[:attr].to_s : 'content'
			@must_be_present = details[:must_be_present] == true
			@value_transform = details[:value_transform]
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

			!!@value_transform ? @value_transform.call(value) : value
		end
	end
end