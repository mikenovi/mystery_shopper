require 'common_helpers'

describe MysteryShopper::KeyValueDetailDefinitionEntry do
  describe "initialize" do
    it "calls extract_key_value_definitions" do
      MysteryShopper::KeyValueDetailDefinitionEntry.any_instance.expects(:extract_key_value_definition).once
      MysteryShopper::KeyValueDetailDefinitionEntry.new :test, { :identifier => :test_tag, :key => 'something', :value => 'something else', :type => :key_value }
    end
  end

  describe "get_value" do
    before do
      @definition = MysteryShopper::KeyValueDetailDefinitionEntry.new :test, { :identifier => 'table.specifications', :type => :key_value, :key => "td:nth-child(odd)", :value => 'td:nth-child(even)'}
    end

    it "returns an empty hash if no matching key-value pairs" do
      content = <<-example
        <table class="specifications">
          <tr></tr>
        </table>
      example

      @definition.get_value(content).must_be_instance_of Hash
      @definition.get_value(content).must_be_empty
    end

    it "throws an exception if there are not equal numbers of keys and values" do
      content = <<-example
        <table class="specifications">
          <tr><td>Width</td><td>32"</td><td>Height<td>45"</td></tr>
          <tr><td>Weight</td><td>40lbs</td><td>Depth</td></tr>
        </table>
      example
      err = ->{ @definition.get_value content }.must_raise ArgumentError
      err.message.must_equal  "unequal number of keys and values"
    end

    it "returns a hash if there are key-value pairs" do
      key_value = { "Width" => '32"', "Height" => '45"', "Weight" => "40lbs", "Depth" => '12"'}
      content = '<table class="specifications">'
      key_value.each { |key, value| content += "<td>#{key}</td><td>#{value}</td>"}
      content += "</table>"
  
      @definition.get_value(content).must_equal key_value
    end
  end

  describe "extract_key_value_definition" do
    before do
      @definition = MysteryShopper::KeyValueDetailDefinitionEntry.allocate
    end

    it "raises an exception if key is not defined" do
      def_hash = {:value => 'something'}

      err = ->{ @definition.send(:extract_key_value_definition, def_hash) }.must_raise ArgumentError
      err.message.must_equal "no 'key' defined"
    end

    it "raises an exception if value is not defined" do
      def_hash = {:key => 'something'}

      err = ->{ @definition.send(:extract_key_value_definition, def_hash) }.must_raise ArgumentError
      err.message.must_equal "no 'value' defined"
    end

    it "sets key_definition and value_definition if properly defined" do
      def_hash = {:value => 'something_else', :key => 'something'}
      @definition.send(:extract_key_value_definition, def_hash)

      @definition.key_definition.must_equal 'something'
      @definition.value_definition.must_equal 'something_else'
    end
  end
end