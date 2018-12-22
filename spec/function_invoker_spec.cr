require "./spec_helper"
require "webmock"


describe FunctionInvoker do
  describe "invoke" do
    context "with a POST request" do
      it "makes a HTTP call with the given data" do
        WebMock.stub(:post, "gateway:8080/function/some_function").
          with(body: "body").
          to_return(status: 200, body: "response")

        resp = FunctionInvoker::Function.new("some_function").invoke("body")
        resp.should eq JSON::Any.new("response")
      end
    end

    context "with a GET request" do
      it "makes a HTTP call with the given data" do
        WebMock.stub(:get, "gateway:8080/function/some_function").
          with(body: "some body").
          to_return(status: 200, body: "response")

        resp = FunctionInvoker::Function.new("some_function", "GET").invoke(
          "some body"
        )
        resp.should eq JSON::Any.new("response")
      end
    end

    context "with an error" do
      it "raises a FunctionException" do
        expect_raises FunctionInvoker::FunctionException do
          FunctionInvoker::Function.new("some test").invoke
        end
      end

      context "with ignore_errors: true" do
        it "can ignore errors" do
          resp = FunctionInvoker::Function.new("some test").
            invoke(ignore_errors: true)
          resp.should eq JSON::Any.new("")
        end
      end
    end
  end
end
