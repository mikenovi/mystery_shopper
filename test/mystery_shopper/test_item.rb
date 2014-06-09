require 'common_includes'

describe MysteryShopper::Item do
  before do
    @valid_definition = {
      :name => {:identifier => '#name', :must_be_present => true},
      :image => {:identifier => 'img#main', :attr => 'src', :must_be_present => true},
      :listing_url => {:identifier => '#name', :attr => 'href', :must_be_present => true},
      :price => {:identifier => '#price', :must_be_present => false, :data_type => 'Float'},
    }
  end

  describe "load definition" do
    it "successfully loads valid definition" do
      item = MysteryShopper::Item.new
      item.send(:load_definition, @valid_definition)

      defs = item.instance_variable_get(:@definitions)
      defs.count.must_equal @valid_definition.count
    end

    it "throws exception with invalid definition" do
      invalid_definition = @valid_definition
      invalid_definition[:bad_definiton] = {:must_be_present => true}

      item = MysteryShopper::Item.new
      err = ->{ item.send(:load_definition, @valid_definition) }.must_raise ArgumentError
      err.message.must_equal "no 'identifier' defined"
    end
  end

  describe "parse" do
    before do
      @item = MysteryShopper::Item.new
      @item.send(:load_definition, @valid_definition)
    end

    it "successfully parses record with optional values" do
      test_record = %Q{
        <a id="name" href="http://example.com">Turbo Test</a>
        <img id="main" src="http://example.com/test.png" />
        <div id="price">3.50</div>
      }

      @item.parse(test_record)
      @item.name.must_equal "Turbo Test"
      @item.image.must_equal "http://example.com/test.png"
      @item.listing_url.must_equal "http://example.com"
      @item.price.must_equal "3.50"
    end

    it "successfully parses minimum record" do
      test_record = %Q{
        <a id="name" href="http://example.com">Turbo Test</a>
        <img id="main" src="http://example.com/test.png" />
      }

      @item.parse(test_record)
      @item.name.must_equal "Turbo Test"
      @item.image.must_equal "http://example.com/test.png"
      @item.listing_url.must_equal "http://example.com"
      @item.price.must_be_nil
    end

    it "throws an exception if missing required element" do
      test_record = %Q{
        <a id="name" href="http://example.com">Turbo Test</a>
        <div id="price">3.50</div>
      }

      err = ->{ @item.parse(test_record) }.must_raise NameError
      err.message.must_equal "Element 'img#main' could not be found."
    end

    it "throws an exception if missing required value" do
      test_record = %Q{
        <a id="name" href="http://example.com"></a>
        <img id="main" src="http://example.com/test.png" />
        <div id="price">3.50</div>
      }

      err = ->{ @item.parse(test_record) }.must_raise NameError
      err.message.must_equal "Value for '#name' 'content' could not be found."
    end
  end
end