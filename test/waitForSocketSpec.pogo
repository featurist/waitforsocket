waitForSocket = require '../index'
http = require 'http'
should = require 'chai'.should()

describe 'portwait'
  server = nil
  listening = nil

  beforeEach
    server := http.createServer()
    listening := false
    server.on 'listening'
      listening := true

  afterEach
    if (listening)
      server.close()

  it 'should wait until port is open' =>
    openYet = false
    @{
      waitForSocket('localhost', 12345, timeout: 1000)!
      openYet := true
    }()

    openYet.should.equal (false, 'before wait')
    setTimeout ^ 40!
    openYet.should.equal (false, 'after wait')
    server.listen 12345
    openYet.should.equal (false, 'after listen')
    setTimeout ^ 40!
    openYet.should.equal (true, 'after listen and wait')

  it 'should throw error if it times out' =>
    error = nil

    @{
      try
        waitForSocket('localhost', 12345, timeout: 250)!
      catch (e)
        error := e
    }()

    setTimeout ^ 1000!
    should.exist(error)
    error.message.should.equal ('timeout: could not connect to localhost:12345')
