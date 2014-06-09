require 'common_includes'

describe MysteryShopper::Configuration do
  describe "config" do
    it "creates a singleton" do
      config_1 = MysteryShopper::Configuration.config
      config_2 = MysteryShopper::Configuration.config

      config_1.must_be_same_as config_2
    end

    describe "source" do
      describe "new source" do
        it "creates a new source" do
          MysteryShopper::Configuration.config.test_source.must_be_kind_of MysteryShopper::Source
        end

        it "accepts values for a source" do
           MysteryShopper::Configuration.config.test_source.product_listing = "Product Listing"
           MysteryShopper::Configuration.config.test_source.product_listing.must_equal "Product Listing"
        end
      end

      describe "existing source" do
        before do
          MysteryShopper::Configuration.config.test_source.product_listing = "Product Listing"
        end

        it "retrieves an existing source" do
          MysteryShopper::Configuration.config.test_source.product_preview = "Product Preview"
          MysteryShopper::Configuration.config.instance_variable_get(:@sources).count.must_equal 1
        end
      end
    end
  end

  describe "configure" do
    it "allow block level access" do
      MysteryShopper::Configuration.configure do |config|
        config.test_source.product_listing = "Product Listing"
        config.test_source.product_preview = "Product Preview"
        config.test_source.product = "Product"
      end

      MysteryShopper::Configuration.config.instance_variable_get(:@sources).count.must_equal 1
    end
  end
end