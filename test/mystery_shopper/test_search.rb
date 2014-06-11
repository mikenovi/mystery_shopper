require 'common_helpers'

describe MysteryShopper::Search do
  before do
    MysteryShopper::Configuration.configure do |config|
      config.test_source.search_url = "http://search.example.com?page=%%page%%"
    end
  end

  describe "initialize" do
    it "succeeds if search URL is defined" do
      MysteryShopper::Search.new('test_source')
    end

    it "throws an exception if the search URL is undefined" do
      err = ->{ MysteryShopper::Search.new('invalid_source') }.must_raise NameError
      err.message.must_equal "no valid search url defined"
    end
  end

  describe "construct url" do
    it "constructs the search URL with stepped page number" do
      search = MysteryShopper::Search.new('test_source')
      search.send(:construct_search_url, 5).must_equal "http://search.example.com?page=5"
    end
  end

  describe "search" do
    it "returns a listing object on successful search" do
      search_url = "http://testsearch.example.com?page=3&term=search_term"
      search_response_body = "Body to parse"

      search = MysteryShopper::Search.new('test_source')
      search.expects(:construct_search_url).returns(search_url)
      response = Typhoeus::Response.new(code: 200, body: search_response_body)
      Typhoeus.stub(search_url).and_return(response)

      MysteryShopper::Listing.any_instance().expects(:parse).with(search_response_body)

      response = search.perform_search('search_term', 3)
      response.must_be_kind_of MysteryShopper::Listing
    end
  end
end