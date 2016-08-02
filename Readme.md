# Proof of Concept of a Batch Requester

This is a PoC based on Facebook's docs, 
[making multiple requests](https://developers.facebook.com/docs/graph-api/making-multiple-requests). 
This allows to batch multiple API requests on a single round-trip.

The idea is to have a service that is able to communicate to the other components. This service is in charge of parsing
and distributing the calls to other services, waiting for the answer and merging it all together.

More powerful features could be supported if using JsonPath(http://goessner.net/articles/JsonPath/) to have a pipeline.
A request could use as input data from a previous request output.

### Fetching all the metrics from a resource (see [test.rb](test.rb)). 
#### Request
```javascript
{
   "batch":[
      {
         "method":"get",
         "url":"hawkular/metrics/availability/AI~R~%5b19e21e94-a2e9-4f92-8c6a-878d91630160%2fLocal~~%5d~AT~Server%20Availability~Server%20Availability"
      },
      {
         "method":"get",
         "url":"hawkular/metrics/gauges/MI~R~%5b19e21e94-a2e9-4f92-8c6a-878d91630160%2fLocal~~%5d~MT~WildFly%20Aggregated%20Web%20Metrics~Aggregated%20Active%20Web%20Sessions"
      },
      {
         "method":"get",
         "url":"hawkular/metrics/counters/MI~R~%5b19e21e94-a2e9-4f92-8c6a-878d91630160%2fLocal~~%5d~MT~WildFly%20Aggregated%20Web%20Metrics~Aggregated%20Expired%20Web%20Sessions"
      },
      {
         "method":"get",
         "url":"hawkular/metrics/gauges/MI~R~%5b19e21e94-a2e9-4f92-8c6a-878d91630160%2fLocal~~%5d~MT~WildFly%20Aggregated%20Web%20Metrics~Aggregated%20Max%20Active%20Web%20Sessions"
      },
      {
         "method":"get",
         "url":"hawkular/metrics/counters/MI~R~%5b19e21e94-a2e9-4f92-8c6a-878d91630160%2fLocal~~%5d~MT~WildFly%20Aggregated%20Web%20Metrics~Aggregated%20Rejected%20Web%20Sessions"
      },
      {
         "method":"get",
         "url":"hawkular/metrics/counters/MI~R~%5b19e21e94-a2e9-4f92-8c6a-878d91630160%2fLocal~~%5d~MT~WildFly%20Aggregated%20Web%20Metrics~Aggregated%20Servlet%20Request%20Count"
      },
      {
         "method":"get",
         "url":"hawkular/metrics/counters/MI~R~%5b19e21e94-a2e9-4f92-8c6a-878d91630160%2fLocal~~%5d~MT~WildFly%20Aggregated%20Web%20Metrics~Aggregated%20Servlet%20Request%20Time"
      },
      {
         "method":"get",
         "url":"hawkular/metrics/counters/MI~R~%5b19e21e94-a2e9-4f92-8c6a-878d91630160%2fLocal~~%5d~MT~WildFly%20Memory%20Metrics~Accumulated%20GC%20Duration"
      },
      {
         "method":"get",
         "url":"hawkular/metrics/gauges/MI~R~%5b19e21e94-a2e9-4f92-8c6a-878d91630160%2fLocal~~%5d~MT~WildFly%20Memory%20Metrics~Heap%20Committed"
      },
      {
         "method":"get",
         "url":"hawkular/metrics/gauges/MI~R~%5b19e21e94-a2e9-4f92-8c6a-878d91630160%2fLocal~~%5d~MT~WildFly%20Memory%20Metrics~Heap%20Max"
      },
      {
         "method":"get",
         "url":"hawkular/metrics/gauges/MI~R~%5b19e21e94-a2e9-4f92-8c6a-878d91630160%2fLocal~~%5d~MT~WildFly%20Memory%20Metrics~Heap%20Used"
      },
      {
         "method":"get",
         "url":"hawkular/metrics/gauges/MI~R~%5b19e21e94-a2e9-4f92-8c6a-878d91630160%2fLocal~~%5d~MT~WildFly%20Memory%20Metrics~NonHeap%20Committed"
      },
      {
         "method":"get",
         "url":"hawkular/metrics/gauges/MI~R~%5b19e21e94-a2e9-4f92-8c6a-878d91630160%2fLocal~~%5d~MT~WildFly%20Memory%20Metrics~NonHeap%20Used"
      },
      {
         "method":"get",
         "url":"hawkular/metrics/gauges/MI~R~%5b19e21e94-a2e9-4f92-8c6a-878d91630160%2fLocal~~%5d~MT~WildFly%20Threading%20Metrics~Thread%20Count"
      }
   ]
}
```


#### Response
```javascript
[
   {
      "code":200,
      "body":{
         "id":"AI~R~[19e21e94-a2e9-4f92-8c6a-878d91630160/Local~~]~AT~Server Availability~Server Availability",
         "dataRetention":7,
         "type":"availability",
         "tenantId":"hawkular",
         "minTimestamp":1470170976002,
         "maxTimestamp":1470173746000
      }
   },
   {
      "code":200,
      "body":{
         "id":"MI~R~[19e21e94-a2e9-4f92-8c6a-878d91630160/Local~~]~MT~WildFly Aggregated Web Metrics~Aggregated Active Web Sessions",
         "dataRetention":7,
         "type":"gauge",
         "tenantId":"hawkular",
         "minTimestamp":1470171006010,
         "maxTimestamp":1470173713001
      }
   },
   {
      "code":200,
      "body":{
         "id":"MI~R~[19e21e94-a2e9-4f92-8c6a-878d91630160/Local~~]~MT~WildFly Aggregated Web Metrics~Aggregated Expired Web Sessions",
         "dataRetention":7,
         "type":"counter",
         "tenantId":"hawkular",
         "minTimestamp":1470171006014,
         "maxTimestamp":1470173713004
      }
   },
   {
      "code":200,
      "body":{
         "id":"MI~R~[19e21e94-a2e9-4f92-8c6a-878d91630160/Local~~]~MT~WildFly Aggregated Web Metrics~Aggregated Max Active Web Sessions",
         "dataRetention":7,
         "type":"gauge",
         "tenantId":"hawkular",
         "minTimestamp":1470171006035,
         "maxTimestamp":1470173713008
      }
   },
   {
      "code":200,
      "body":{
         "id":"MI~R~[19e21e94-a2e9-4f92-8c6a-878d91630160/Local~~]~MT~WildFly Aggregated Web Metrics~Aggregated Rejected Web Sessions",
         "dataRetention":7,
         "type":"counter",
         "tenantId":"hawkular",
         "minTimestamp":1470171006018,
         "maxTimestamp":1470173713007
      }
   },
   {
      "code":200,
      "body":{
         "id":"MI~R~[19e21e94-a2e9-4f92-8c6a-878d91630160/Local~~]~MT~WildFly Aggregated Web Metrics~Aggregated Servlet Request Count",
         "dataRetention":7,
         "type":"counter",
         "tenantId":"hawkular",
         "minTimestamp":1470171006021,
         "maxTimestamp":1470173713006
      }
   },
   {
      "code":200,
      "body":{
         "id":"MI~R~[19e21e94-a2e9-4f92-8c6a-878d91630160/Local~~]~MT~WildFly Aggregated Web Metrics~Aggregated Servlet Request Time",
         "dataRetention":7,
         "type":"counter",
         "tenantId":"hawkular",
         "minTimestamp":1470171006003,
         "maxTimestamp":1470173713002
      }
   },
   {
      "code":200,
      "body":{
         "id":"MI~R~[19e21e94-a2e9-4f92-8c6a-878d91630160/Local~~]~MT~WildFly Memory Metrics~Accumulated GC Duration",
         "dataRetention":7,
         "type":"counter",
         "tenantId":"hawkular",
         "minTimestamp":1470171006038,
         "maxTimestamp":1470173713002
      }
   },
   {
      "code":200,
      "body":{
         "id":"MI~R~[19e21e94-a2e9-4f92-8c6a-878d91630160/Local~~]~MT~WildFly Memory Metrics~Heap Committed",
         "dataRetention":7,
         "type":"gauge",
         "tenantId":"hawkular",
         "minTimestamp":1470171006036,
         "maxTimestamp":1470173713008
      }
   },
   {
      "code":200,
      "body":{
         "id":"MI~R~[19e21e94-a2e9-4f92-8c6a-878d91630160/Local~~]~MT~WildFly Memory Metrics~Heap Max",
         "dataRetention":7,
         "type":"gauge",
         "tenantId":"hawkular",
         "minTimestamp":1470171006018,
         "maxTimestamp":1470173713008
      }
   },
   {
      "code":200,
      "body":{
         "id":"MI~R~[19e21e94-a2e9-4f92-8c6a-878d91630160/Local~~]~MT~WildFly Memory Metrics~Heap Used",
         "dataRetention":7,
         "type":"gauge",
         "tenantId":"hawkular",
         "minTimestamp":1470170976025,
         "maxTimestamp":1470173725000
      }
   },
   {
      "code":200,
      "body":{
         "id":"MI~R~[19e21e94-a2e9-4f92-8c6a-878d91630160/Local~~]~MT~WildFly Memory Metrics~NonHeap Committed",
         "dataRetention":7,
         "type":"gauge",
         "tenantId":"hawkular",
         "minTimestamp":1470171006015,
         "maxTimestamp":1470173713006
      }
   },
   {
      "code":200,
      "body":{
         "id":"MI~R~[19e21e94-a2e9-4f92-8c6a-878d91630160/Local~~]~MT~WildFly Memory Metrics~NonHeap Used",
         "dataRetention":7,
         "type":"gauge",
         "tenantId":"hawkular",
         "minTimestamp":1470170976043,
         "maxTimestamp":1470173725003
      }
   },
   {
      "code":200,
      "body":{
         "id":"MI~R~[19e21e94-a2e9-4f92-8c6a-878d91630160/Local~~]~MT~WildFly Threading Metrics~Thread Count",
         "dataRetention":7,
         "type":"gauge",
         "tenantId":"hawkular",
         "minTimestamp":1470171066022,
         "maxTimestamp":1470173711001
      }
   }
]
```
