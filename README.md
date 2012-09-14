dhutty-nginx
============

This is a puppet module to manage configuration of the NGINX webserver.

It's based very heavily on the work of James Fryman and Puppetlabs and their contributors. However, there are some significant differences in the implementation.

Example Usage
-------------

    class {'nginx':
      nx_worker_processes => 2,
      nx_worker_connections => 2048,
      nx_client_max_body_size => '20m',
    }
    nginx::resource::vhost { 'test.example.com':
      ensure => present,
      server_names => ['test.example.com','foo.example.com'],
      listen_port => 443,
      www_root => '/var/www/nginx-default',
      ssl => true,
      ssl_cert => '/tmp/server.crt',
      ssl_key => '/tmp/server.pem',
    }
    nginx::resource::location { 'foo-ws':
      ensure => present,
      vhost => 'foo.example.com',
      location => '/ws',
      match_type => '~',
      proxy => 'http://app1',
      proxy_set_headers => {
      'REMOTE_ADDR' => '$remote_addr',
      'HTTP_HOST' => '$http_host',
      },
    }
    nginx::resource::upstream { 'app1':
      ensure => present,
      members => [
      'localhost:3000 weight=1',
      'unix:/var/run/appserver.sock weight=10',
      'otherserver.example.com:8080 backup',
      ],
    }

Notes
-----

I have attempted to make it easier to override module defaults, by using this kind of pattern:

    $nx_worker_processes_real = $nx_worker_processes ? {
      'UNSET' => $::nginx::params::nx_worker_processes,
      default => $nx_worker_processes,
    }

which allows this kind of syntax to override:

    class {'nginx':
      nx_worker_processes => 2,
      nx_worker_connections => 2048,
      nx_client_max_body_size => '20m',
    }

* The implementation of ssl configurations is differen; SSL is only done at the server {...} context level, locations do not (need to) know whether they are ssl or not.
* The `force_ssl` flag can be used to include a directive that rewrites all requests to the equivalent request but with the https scheme.
* There is more flexibility with proxy settings, these are now easier to override on a per server/location basis.
* I think I have defeated a bug where changing the manifest would not necessarily result in an update to the nginx config.
* A little more accurate chaining of resources such that the service is refreshed if and only if its config has changed.
* More closely following the style guide
