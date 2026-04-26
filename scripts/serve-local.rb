#!/usr/bin/env ruby

require "socket"

HOST = "127.0.0.1"
PORT = 4001
WATCH_INTERVAL_SECONDS = 1
DEBOUNCE_SECONDS = 0.6
EXCLUDED_DIRECTORIES = [
  ".bundle",
  ".git",
  ".jekyll-cache",
  ".sass-cache",
  "_site",
  "node_modules",
  "vendor"
].freeze

def port_available?
  server = TCPServer.new(HOST, PORT)
  server.close
  true
rescue Errno::EADDRINUSE
  false
end

def ignored_path?(path)
  path.split(File::SEPARATOR).any? { |part| EXCLUDED_DIRECTORIES.include?(part) }
end

def watched_files
  Dir.glob("**/*", File::FNM_DOTMATCH)
    .reject { |path| ignored_path?(path) }
    .select { |path| File.file?(path) }
end

def snapshot
  watched_files.to_h { |path| [path, [File.mtime(path).to_f, File.size(path)]] }
end

def start_server
  warn "Local preview: http://#{HOST}:#{PORT}"
  Process.spawn(
    "bundle",
    "exec",
    "jekyll",
    "serve",
    "--host",
    HOST,
    "--port",
    PORT.to_s,
    "--no-watch",
    pgroup: true
  )
end

def stop_server(pid)
  return unless pid

  Process.kill("INT", -pid)
  Process.wait(pid)
rescue Errno::ESRCH, Errno::ECHILD
  nil
end

unless port_available?
  warn "Local preview already appears to be running at http://#{HOST}:#{PORT}"
  exit 0
end

server_pid = start_server
current_snapshot = snapshot

["INT", "TERM"].each do |signal|
  trap(signal) do
    warn "Stopping local preview."
    stop_server(server_pid)
    exit 0
  end
end

loop do
  sleep WATCH_INTERVAL_SECONDS

  if Process.wait(server_pid, Process::WNOHANG)
    warn "Jekyll process exited. Restarting local preview."
    server_pid = start_server
    current_snapshot = snapshot
    next
  end

  next_snapshot = snapshot

  next if next_snapshot == current_snapshot

  sleep DEBOUNCE_SECONDS
  current_snapshot = snapshot

  warn "Changes detected. Restarting local preview."
  stop_server(server_pid)
  server_pid = start_server
end
