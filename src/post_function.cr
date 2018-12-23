require "http/client"
require "json"

module FunctionInvoker
  class PostFunction
    def initialize(@name : String, @gateway : String); end

    def invoke(data : String)
      response = HTTP::Client.post(
        "#{@gateway}/function/#{@name}",
        headers: nil,
        body: data
      )
      JSON::Any.new(response.body)
    end
  end
end
