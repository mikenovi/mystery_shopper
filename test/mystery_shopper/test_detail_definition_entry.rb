require 'mystery_shopper'

require 'minitest/spec'
require 'minitest/autorun'

describe MysteryShopper::DetailDefinitionEntry do
	it "accepts identifier" do
		@test_detail = MysteryShopper::DetailDefinitionEntry.new :test, { :identifier => :test_tag }
		@test_detail.identifier.must_equal :test_tag
	end

	describe "defaults" do
		before do
			@test_detail = MysteryShopper::DetailDefinitionEntry.new :test, { :identifier => :test_tag }
		end

		it "defaults to String type" do
			@test_detail.data_type.must_equal String
		end

		it "defaults to text attribute" do
			@test_detail.attribute.must_equal "text"
		end

		it "defaults to not needing to be present" do
			@test_detail.must_be_present.must_equal false
		end
	end

	it "overrides data type with valid data class" do
		@test_detail = MysteryShopper::DetailDefinitionEntry.new :test, { :identifier => :test_tag, :data_type => 'Float' }
		@test_detail.data_type.must_equal Float
	end

	it "overrides attribute with provided name" do
		@test_detail = MysteryShopper::DetailDefinitionEntry.new :test, { :identifier => :test_tag, :attr => :src }
		@test_detail.attribute.must_equal 'src'
	end
	
	it "overrides must_be_present with provided name" do
		@test_detail = MysteryShopper::DetailDefinitionEntry.new :test, { :identifier => :test_tag, :must_be_present => true }
		@test_detail.must_be_present.must_equal true
	end
end