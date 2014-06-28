module MysteryShopper
  class Item
    def method_missing(m, *args, &block)
      return self.instance_variable_get("@#{m}") if self.instance_variable_defined?("@#{m}")
      super(m, *args, &block)
    end

    def parse(content)
      @definitions.each do |detail|
        self.instance_variable_set("@#{detail.name}", detail.get_value(content))
      end

      self
    end

    protected
    def load_definition(def_hash)
      @definitions = []
      def_hash.each do |key, details|
        @definitions << DetailDefinitionEntry.create(key, details)
      end       
    end
  end
end