require 'net/http'
require 'json'
require 'optparse'

options = {}
options[:once] = false
options[:fire] = false
STATE_FILE = '/tmp/zk_servers.json'

OptionParser.new do |opts|
  opts.banner = "Usage: zkdiscovery.rb [options]"
  opts.on("-o", "--once", "Run once and output server list") do |v|
    options[:once] = true
  end
  opts.on("-f", "--fire", "Fire handlers in --once mode") do |v|
    options[:fire] = true
  end
end.parse!(ARGV)

def get_servers
  host = ENV['EXHIBITOR_HOST'] || '127.0.0.1'
  port = ENV['EXHIBITOR_PORT'] || 8181
  user = ENV['EXHIBITOR_USER'] || 'exhibitor'
  pass = ENV['EXHIBITOR_PASS']

  Net::HTTP.start(host, port) do |http|
    req = Net::HTTP::Get.new('/exhibitor/v1/cluster/status')
    req.basic_auth(user, pass) if pass
    res = http.request(req)
    if res.code == '200'
      JSON.parse(res.body)
    else
      nil
    end
  end
end

def run_handlers
  # TODO(jpg): Could probably do a better job of this
  Dir['/etc/exhibitor/handlers.d/*'].select { |f| File.executable? f }.each do |h|
    `#{h}`
  end
end

def write_state(servers)
  File.write(STATE_FILE, servers.to_json)
end

def read_state
  JSON.parse(File.read(STATE_FILE))
end

def hostnames(servers)
  servers.map {|s| s['hostname']}
end

if options[:once]
  servers = get_servers
  write_state(servers)
  puts hostnames(servers).join(',') if servers
  run_handlers if options[:fire]
  exit
end

puts 'Running in monitor mode'

while true do
  servers = get_servers
  state_file = '/tmp/zk_servers.json'
  if File.exists?(STATE_FILE)
    old_servers = read_state
    if hostnames(servers) != hostnames(old_servers)
      puts 'Server list has changed'
      run_handlers
    end
  else # First run
    run_handlers
  end
  write_state(servers) # Write the new state
  sleep 30
end
