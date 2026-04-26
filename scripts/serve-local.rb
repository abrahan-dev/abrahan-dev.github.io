#!/usr/bin/env ruby

require "socket"

HOST = "127.0.0.1"
DEFAULT_PORT = 4001

def port_available?
  server = TCPServer.new(HOST, DEFAULT_PORT)
  server.close
  true
rescue Errno::EADDRINUSE
  false
end

unless port_available?
  warn "Local preview already appears to be running at http://#{HOST}:#{DEFAULT_PORT}"
  exit 0
end

warn "Local preview: http://#{HOST}:#{DEFAULT_PORT}"

exec "bundle", "exec", "jekyll", "serve", "--host", HOST, "--port", DEFAULT_PORT.to_s
