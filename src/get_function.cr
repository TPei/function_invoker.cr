require "http/client"
require "json"

module FunctionInvoker
  class GetFunction
    def initialize(@name : String, @gateway : String); end

    def invoke(data : String)
      response = HTTP::Client.get(
        "#{@gateway}/function/#{@name}",
        headers: nil,
        body: data
      )
      JSON::Any.new(response.body)
    end
  end
end
