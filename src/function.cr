require "json"
require "./get_function"
require "./post_function"

module FunctionInvoker
  class Function
    @name : String
    @method : String

    def initialize(@name, method = "POST")
      @method = method.upcase
      @gateway = ENV["GATEWAY"]? || ENV["gateway"]? || "gateway:8080"
    end

    def invoke(data : String = "", ignore_errors : Bool = false)
      if @method == "POST"
        PostFunction.new(@name, @gateway.to_s).invoke(data)
      elsif @method == "GET"
        GetFunction.new(@name, @gateway.to_s).invoke(data)
      end
    rescue ex : Exception
      if ignore_errors
        return JSON::Any.new("")
      end
      raise FunctionException.new(ex.message)
    end

    def invoke(data : JSON::Any | Nil, ignore_errors : Bool = false)
      invoke(data.to_s, ignore_errors)
    end
  end

  class FunctionException < Exception; end
end
