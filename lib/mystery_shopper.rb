require 'mystery_shopper/detail_definition_entry'
require 'mystery_shopper/listing'
require 'mystery_shopper/item'
require 'mystery_shopper/configuration'
require 'mystery_shopper/product_preview'

module MysteryShopper
  def self.configure
  end

	def self.get_products(search, sources=nil)
		sources = [] if source.nil?
		sources = [sources] if !sources.is_a? Array
	end
end