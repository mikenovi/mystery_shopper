module MysteryShopper
  class ProductPreview < Item
    def initialize(def_hash)
      self.load_definition(def_hash)
    end
  end
end