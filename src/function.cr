require "http/client"
require "json"

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
        response = HTTP::Client.post("#{@gateway}/function/#{@name}", headers: nil, body: data)
        JSON::Any.new(response.body)
      elsif @method == "GET"
        response = HTTP::Client.get("#{@gateway}/function/#{@name}", headers: nil, body: data)
        JSON::Any.new(response.body)
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
