# Wait for a Socket to Open

    var waitForSocket = require('waitforsocket');

    waitForSocket('localhost', 4567, {timeout: 2000}).then(function () {
      console.log("socket open");
      // do stuff with socket, connect via HTTP, Redis, etc.
    }, function (error) {
      console.log("socket did not open: ", error);
    });

## API

    waitForSocket(host, port, [options]) => promise

* `host` hostname, i.e. `localhost` or `example.com`
* `port` the port, i.e. `80`, or `6379`
* `options` an object containing the following properties
    * `timeout` the timeout in milliseconds, default: 1000 (1 sec)

returns a promise.
