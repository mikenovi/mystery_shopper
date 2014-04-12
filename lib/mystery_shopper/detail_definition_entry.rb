module MysteryShopper
	class DetailDefinitionEntry
		attr_accessor :name, :identifier, :data_type, :attribute, :must_be_present

		def initialize(name, details)
			@name = name

			self.extract_details(details)
		end

		def extract_details(details)
			#TODO: Throw exeception if no identifier is defined
			Exception if details[:identifier].empty?
			@identifier = details[:identifier]

			# TODO Convert data type to class
			@data_type = !details[:data_type].nil? ? Object.const_get(details[:data_type]) : String
			@attribute = details[:attr] ? details[:attr].to_s : 'text'
			@must_be_present = details[:must_be_present] == true
		end
	end
end