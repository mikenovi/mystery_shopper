module MysteryShopper
  class Source
    attr_accessor :name, :product_listing, :product_preview, :product
  end

  class Configuration
    include Singleton

    def initialize
      @sources = Array.new
    end

    def method_missing(m, *args, &block)
      return self.get_source(m)
    end

    def get_source(source_name)
      sources = @sources.select { |s| s.name == source_name }
      if sources.empty? 
        source = Source.new
        source.name = source_name
        @sources << source
      else
        source = sources[0]
      end
      source
    end

    def self.config
      Configuration.instance
    end

    def self.configure
      yield config
    end
  end
end