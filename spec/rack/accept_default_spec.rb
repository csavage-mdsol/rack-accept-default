require 'spec_helper'

describe Rack::AcceptDefault do
  include Rack::Test::Methods

  context 'given no argument for default' do
    def app
      rack_app = lambda { |env| [200, {}, "app" ] }
      Rack::AcceptDefault.new(rack_app)
    end

    it "should set */* as a default header" do
      get '/'
      last_response.should be_ok
      last_request.env["HTTP_ACCEPT"].should == '*/*'
    end

    it "should override given nil Accept header" do
      get "/", {}, { "HTTP_ACCEPT" => nil }
      last_response.should be_ok
      last_request.env["HTTP_ACCEPT"].should == "*/*"
    end

    it "should not override given Accept header" do
      get '/', {}, { 'HTTP_ACCEPT' => "application/json" }
      last_response.should be_ok
      last_request.env["HTTP_ACCEPT"].should == "application/json"
    end
  end

  context 'given an argument for default' do
    def app
      rack_app = lambda { |env| [200, {}, "app" ] }
      Rack::AcceptDefault.new(rack_app, "application/json")
    end

    it "should override the */* Accept header with the default if the User Agent is google-api-ruby-client" do
      get '/', {}, { 'HTTP_ACCEPT' => "*/*", 'HTTP_USER_AGENT' => "google-api-ruby-client/0.4.0 Mac OS X/10.9.4" }
      last_response.should be_ok
      last_request.env["HTTP_ACCEPT"].should == "application/json"
    end

    it "should not override a non */* header" do
      get '/', {}, { 'HTTP_ACCEPT' => "text/html", 'HTTP_USER_AGENT' => "google-api-ruby-client/0.4.0 Mac OS X/10.9.4" }
      last_response.should be_ok
      last_request.env["HTTP_ACCEPT"].should == "text/html"
    end
  end
end
