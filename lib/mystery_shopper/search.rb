require 'typhoeus'

module MysteryShopper
	class Search
		def initialize(source)
      @source = source
      raise NameError.new "no valid search url defined" unless MysteryShopper::Configuration.config.send(@source).search_url
		end

		def perform_search(search_term, page=1)
			response = Typhoeus.get(self.construct_search_url(page), followlocation: true)
      if response.success?
        listing = MysteryShopper::Listing.new @source
        listing.parse response.body
        listing
      else
        raise IOError.new "request timed out" if response.timed_out?
        raise IOError.new "no HTTP response" if response.code == 0
        raise IOError.new "failed HTTP request with response #{response.code.to_s}"
      end
		end

    protected
    def construct_search_url(page=1)
      MysteryShopper::Configuration.config.send(@source).search_url.gsub(/%%page%%/, page.to_s)
    end
	end
end