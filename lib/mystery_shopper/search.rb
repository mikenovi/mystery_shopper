require 'uri'
require 'typhoeus'

module MysteryShopper
	class Search
		def initialize(source)
      @source = source
      raise NameError.new "no valid search url defined" unless Configuration.config.send(@source).search_url
		end

		def perform_search(search_term, page=1)
      response = Typhoeus.get(self.construct_search_url(search_term, page), { followlocation: true }.merge(Configuration.config.send(@source).curl_options))
      if response.success?
        listing = Listing.new @source
        listing.parse response.body
      else
        raise IOError.new "request timed out" if response.timed_out?
        raise IOError.new "no HTTP response" if response.code == 0
        raise IOError.new "failed HTTP request with response #{response.code.to_s}"
      end
		end

    protected
    def construct_search_url(search_term, page=1)
      Configuration.config.send(@source).search_url.gsub(/%%search_term%%/, URI::encode_www_form_component(search_term)).gsub(/%%page%%/, page.to_s)
    end
	end
end