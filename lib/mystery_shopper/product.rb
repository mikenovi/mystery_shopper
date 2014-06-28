module MysteryShopper
	class Product < Item
		@@definition_key = :product

		def initialize(source, url=nil)
			@source = source
			self.load_definition(MysteryShopper::Configuration.config.send(@source).send(@@definition_key))
			self.load(url) unless url.nil? || url.strip.empty?
		end

		def load(url)
			response = Typhoeus.get(url, { followlocation: true }.merge(MysteryShopper::Configuration.config.send(@source).curl_options))
      if response.success?
        self.parse(response.body)
      else
        raise IOError.new "request timed out" if response.timed_out?
        raise IOError.new "no HTTP response" if response.code == 0
        raise IOError.new "failed HTTP request with response #{response.code.to_s}"
      end
		end
	end
end