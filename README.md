# function_invoker

Seamlessly call other OpenFaaS functions from your crystal functions.

Simply provide a function name and call it:
```crystal
Function.new("echo").invoke
```

This will make a call to your OpenFaaS gateway to the echo function,
which should be deployed :)

Optionally, provide a http method, provide data or ignore all errors:
```crystal
Function.new("echo", "GET").invoke("some_string", ignore_errors: true)
```

## Installation

0. Have a crystal function :)
```bash
faas template store pull crystal
faas new my-crystal-function --lang crystal
```

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  function_invoker:
    github: tpei/function_invoker.cr
```
2. Run `shards install`

3. Add your gateway address to you function yaml

If nothing is provided, the default of gateway:8080 is used

```yaml
provider:
  name: faas
  gateway: localhost:8080
functions:
  pipe-crystal-test:
    lang: crystal
    handler: ./pipe-crystal-test
    image: pipe-crystal-test:latest
    environment:
      GATEWAY: "faas.production.tpei.com:8080"
```


## Usage
```crystal
require "function_invoker"
```

Optionally, put
```crystal
Function = FunctionInvoker::Function
```
somewhere at the top of your handler class to save some typing :)


### Example Function
```crystal
require "json"
require "function_invoker"

class Handler
  # if FunctionInvoker::Function is too long for you ;)
  Function = FunctionInvoker::Function

  def run(req : String)
    # mistyped function call, with ignore_errors
    data = Function.new("not_a_real_function").invoke(req, ignore_errors:
true)
    data = Function.new("echo", "get").invoke(data)
    data = Function.new("echo").invoke(data.to_s + "MORE DATA")
    return data
  end
end

Handler.new.run("")
```

### Error Handling
For easier error handling, function failures of any kind simply result
in a FunctionException being thrown. The original error message is
passed along to make sense of the error, however you can simply catch
FunctionException if you want to handle errors.
Additionally, you can also pass `ignore_errors: true` to `#invoke` if
you are dealing with a non-mission-critical function that is allowed to
fail.

```crystal
begin
  Function.new("my_func").invoke
rescue ex : FunctionException
  puts ex
end

Function.new("my_func").invoke(ignore_errors: true)
```

## Contributing

1. Fork it (<https://github.com/tpei/function_invoker2/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [TPei](https://github.com/tpei) - creator and maintainer
