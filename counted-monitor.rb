#!/usr/bin/env ruby

require 'net/http'
require 'uri'

def fetch_url(url)
  url = URI.parse(url)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true if url.scheme == 'https'
  response = http.request_get(url.path)
  abort "HTTP error fetching '#{url.to_s}': '#{response.code}: #{response.message}'" unless response.kind_of?(Net::HTTPSuccess)
  return response.body
end

js_url = 'http://interactive.guim.co.uk/2015/the-counted/_list/boot.js'
js = fetch_url(js_url)
json_url_prefix = js.match(/https?:\/\/interactive\.guim\.co\.uk\/2015\/the-counted\/v\/\d+\//) or abort "Could not extract URL from #{js_url}"
puts `curl -O "#{json_url_prefix}files/skeleton.json"`
