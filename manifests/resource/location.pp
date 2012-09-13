# define: nginx::resource::location
#
# This definition creates a new location entry within a virtual host
#
# Parameters:
# [*ensure*] - Enables or disables the specified location (present|absent)
# [*vhost*] - Defines the default vHost for this location entry to include with
# [*location*] - Specifies the URI associated with this location entry
# [*www_root*] - Specifies the location on disk for files to be read from. Cannot be set in conjunction with $proxy
# [*index_files*] - Default index files for NGINX to read when traversing a directory
# [*proxy*] - Proxy server(s) for a location to connect to. Accepts a single value, can be used in conjunction
# with nginx::resource::upstream
# [*proxy_connect_timeout*] - Override the default the proxy connect timeout value of 90 seconds
# [*proxy_redirect*] - Override the default proxy_redirect: 'off'.
# [*proxy_read_timeout*] - Override the default the proxy read timeout value of 90 seconds
# [*proxy_send_timeout*] - Override the default the proxy send timeout value of 90 seconds
# [*match_type*] - URI matching. Use '~' for case-sensitive regex match, '~*' for case-insensitive regex, or leave at default undef for literal match.
# [*proxy_set_headers*] - a hash of { <header_name> => <header_var> } so nginx passes request headers to the upstream.
# [*other_directives*] - a hash of { <directive> => <value> }, to be used to write other nginx directives that this module does not cover.
#
# Actions:
#
# Requires:
#
# Sample Usage:
# nginx::resource::location { 'test2./':
#   ensure   => present,
#   www_root => '/var/www/bob',
#   location => '/',
#   vhost    => 'test2.example.com',
# }
#
# nginx::resource::location { 'foo-ws':
#   ensure     => present,
#   vhost      => 'foo.example.com',
#   location   => '/ws',
#   match_type => '~',
#   proxy      => 'http://appserver1',
#   proxy_set_headers => {
#      'REMOTE_ADDR'  => '$remote_addr',
#      'HTTP_HOST'    => '$http_host',
#   },
# }

define nginx::resource::location(
  $ensure = present,
  $vhost,
  $location,
  $match_type = undef,
  $www_root = undef,
  $index_files = ['index.html', 'index.htm', 'index.php'],
  $proxy = undef,
  $proxy_redirect = undef,
  $proxy_connect_timeout = undef,
  $proxy_read_timeout = undef,
  $proxy_send_timeout = undef,
  $proxy_set_headers = {},
  $other_directives = {}
) {
  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Class['nginx::service']
  }
  $ensure_real = $ensure ? {
    'absent' => absent,
    default  => present,
  }
  if ($www_root  and  $proxy ) {
    fail('A location reference must have exactly one of www_root or proxy defined')
  }
  if (! $www_root  and (! $proxy) ) {
    fail('A location reference must have exactly one of www_root or proxy defined')
  }

# Use proxy template if $proxy is defined, otherwise use directory template.
  if ($proxy) {
    $content_real = template('nginx/vhost/vhost_location_proxy.erb')
  } else {
    $content_real = template('nginx/vhost/vhost_location_directory.erb')
  }
## Create stubs for vHost File Fragment Pattern
  file {"${nginx::nx_conf_dir_real}/conf.d/.frag-${vhost}-500-${name}":
    ensure  => $ensure_real,
    content => $content_real,
  }
}
