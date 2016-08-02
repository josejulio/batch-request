require 'sinatra'
require 'json'
require 'rest_client'

BASE_URL = 'http://localhost:8080'
USERNAME = 'jdoe'
PASSWORD = 'password'

def rest_client(suburl)
  options = Hash.new
  options[:user] = USERNAME
  options[:password] = PASSWORD
  RestClient::Resource.new(BASE_URL, options)[suburl]
end

def http_headers()
  {
    'Hawkular-Tenant': 'hawkular',
    content_type: 'application/json',
    accept: 'application/json'
  }
end

post '/' do
  request_string = request.body.read
  unless request_string.empty?
    data = JSON.parse request_string
    data['batch'].map do |request|
      client = rest_client(request['url'])
      res = case request['method']
            when 'get' then client.get(http_headers())
            when 'post' then client.post(request['body'].to_json, http_headers())
            when 'put' then client.put(request['body'].to_json, http_headers())
            when 'delete' then client.delete(http_headers())
            end
      {
        code: res.code,
        body: res.empty? ? '' : JSON.parse(res)
      }
    end.to_json
  end
end