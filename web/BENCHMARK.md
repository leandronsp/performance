# Benchmark

## No database index

* 1 web worker
* 5 threads
* 10 requests
* 2 concurrent

```
Time taken for tests:   42.854 seconds
Requests per second:    0.23 [#/sec] (mean)
Time per request:       8570.842 [ms] (mean)
Time per request:       4285.421 [ms] (mean, across all concurrent requests)
```

* 1 web worker
* 5 threads
* 32 requests
* 8 concurrent

```
Time taken for tests:   119.493 seconds
Requests per second:    0.27 [#/sec] (mean)
Time per request:       29873.246 [ms] (mean)
Time per request:       3734.156 [ms] (mean, across all concurrent requests)
```

* 4 web workers
* 5 threads
* 32 requests
* 8 concurrent

```
Time taken for tests:   119.394 seconds
Requests per second:    0.27 [#/sec] (mean)
Time per request:       29848.472 [ms] (mean)
Time per request:       3731.059 [ms] (mean, across all concurrent requests)
```

## With database index

* 1 web worker
* 5 threads
* 10 requests
* 2 concurrent

```
Time taken for tests:   3.582 seconds
Requests per second:    2.79 [#/sec] (mean)
Time per request:       716.422 [ms] (mean)
Time per request:       358.211 [ms] (mean, across all concurrent requests)
```

* 1 web worker
* 5 threads
* 32 requests
* 8 concurrent

```
Time taken for tests:   9.312 seconds
Requests per second:    3.44 [#/sec] (mean)
Time per request:       2328.102 [ms] (mean)
Time per request:       291.013 [ms] (mean, across all concurrent requests)

```

* 4 web workers
* 5 threads
* 32 requests
* 8 concurrent

```
Time taken for tests:   9.004 seconds
Requests per second:    3.55 [#/sec] (mean)
Time per request:       2250.986 [ms] (mean)
Time per request:       281.373 [ms] (mean, across all concurrent requests)
```
