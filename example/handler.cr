require "json"
require "function_invoker"

class Handler
  # if FunctionInvoker::Function is too long for you ;)
  Function = FunctionInvoker::Function

  def run(req : String)
    # mistyped function call, with ignore_errors
    data = Function.new("echo-crystals").invoke(req, ignore_errors: true)
    puts data
    data = Function.new("echo-crystal", "get").invoke(data)
    puts data
    data = Function.new("echo-crystal").invoke(data.to_s + "1")
    puts data
    data = Function.new("echo-crystal").invoke(data.to_s + "2")
    puts data
    data = Function.new("echo-crystal").invoke(data.to_s + "3")
    puts data
    data = Function.new("echo-crystal").invoke(data.to_s + "4")
    puts data
    data = Function.new("echo-crystal").invoke(data.to_s + "5")
    return data
  end
end

Handler.new.run("")
