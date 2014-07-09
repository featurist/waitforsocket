net = require 'net'

module.exports (host, port, timeout: 1000) =
  t = timeoutCounter(timeout)

  attemptConnection () =
    promise @(result, error)
      socket = @new net.Socket()
      connection = socket.connect(port, host)
      connection.on 'connect'
        connection.end()
        result()

      connection.on 'error' @(e)
        error(e)

  attemptConnectionUntilTimeout () =
    try
      attemptConnection()!
    catch (e)
      if (t.elapsed())
        @throw @new Error "timeout: could not connect to #(host):#(port)"
      else if (e.code == 'ECONNREFUSED')
        setTimeout ^ 10!
        attemptConnectionUntilTimeout()!

  attemptConnectionUntilTimeout()!

timeoutCounter(timeout) =
  startTime = @new Date().getTime()
  {
    elapsed() =
      now = @new Date().getTime()
      now - startTime > timeout
  }
