require 'rest-client'
require 'hawkular/hawkular_client'

BASE_URL = 'http://localhost:4567'

client = Hawkular::Client.new(
  entrypoint: 'http://localhost:8080',
  credentials: { username: 'jdoe', password: 'password' },
  options: { tenant: 'hawkular' }
)

inventory_metrics = client.inventory.list_metrics_for_resource('t;hawkular/f;19e21e94-a2e9-4f92-8c6a-878d91630160/r;Local~~')

batch = inventory_metrics.map do |im|
  {
    method: 'get',
    url: 'hawkular/metrics/' << case im.type
                                when 'GAUGE' then 'gauges/'
                                when 'AVAILABILITY' then 'availability/'
                                when 'COUNTER' then 'counters/'
                                else ''
                                end << client.inventory.hawk_escape_id(im.id)
  }
end


request = { batch: batch }.to_json
res = RestClient::Resource.new(BASE_URL).post(request)

puts request
puts res