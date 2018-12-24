require "./spec_helper"
require "webmock"

describe FunctionInvoker::GetFunction do
  describe "#invoke" do
    it "makes a HTTP call with the given data to a gateway function" do
      WebMock.stub(:get, "url:8080/function/function").
        with(body: "some body").
        to_return(status: 200, body: "response")

      resp = FunctionInvoker::GetFunction.new("function", "url:8080").invoke(
        "some body"
      )
      resp.should eq JSON::Any.new("response")
    end
  end
end
