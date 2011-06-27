require 'spec_helper'

describe ProductsController do
  
  describe "create" do
    it "should create a new product for me" do
      json = ActiveSupport::JSON.decode("{product:{'title':'abc'}}")
      #request.env['CONTENT_TYPE'] = 'application/json'
      request.env["HTTP_ACCEPT"] = "application/json"
      post :create, json
      response.should be_success
    end
  end

end
  