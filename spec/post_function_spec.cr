require "./spec_helper"
require "webmock"

describe FunctionInvoker::PostFunction do
  describe "#invoke" do
    it "makes a HTTP call with the given data and method" do
      WebMock.stub(:post, "url:8080/function/function").
        with(body: "body").
        to_return(status: 200, body: "response")

      resp = FunctionInvoker::PostFunction.new("function", "url:8080").
        invoke("body")
      resp.should eq JSON::Any.new("response")
    end
  end
end
