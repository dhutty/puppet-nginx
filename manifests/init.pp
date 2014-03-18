# Class: nginx
#
# This module manages NGINX.
#
# Parameters:
#
# There are no default parameters for this class. All module parameters are managed
# via the nginx::params class
#
# Actions:
#
# Requires:
#
# Packaged NGINX
# - RHEL: EPEL or custom package
# - Debian/Ubuntu: Default Install or custom package
#
#
# Sample Usage:
#
# The module works with sensible defaults:
#
# node default {
# class {'nginx':}
# }
#
# You can override various NGINX wide defaults like this:
#
# class {'nginx':
#   nx_worker_processes => 2,
#   nx_worker_connections => 2048,
#   nx_client_max_body_size => '20m',
# }

class nginx (
  $nx_conf_dir = 'UNSET',
  $nx_worker_processes = 'UNSET',
  $nx_worker_connections = 'UNSET',
  $nx_multi_accept = 'UNSET',
  $nx_types_hash_max_size = 'UNSET',
  $nx_sendfile = 'UNSET',
  $nx_keepalive_timeout = 'UNSET',
  $nx_tcp_nodelay = 'UNSET',
  $nx_gzip = 'UNSET',

  $nx_proxy_redirect = 'UNSET',
  $nx_proxy_set_header = 'UNSET',
  $nx_client_body_buffer_size = 'UNSET',
  $nx_client_max_body_size = 'UNSET',
  $nx_proxy_connect_timeout = 'UNSET',
  $nx_proxy_send_timeout = 'UNSET',
  $nx_proxy_read_timeout = 'UNSET',
  $nx_proxy_buffers = 'UNSET',

  $nx_logdir = 'UNSET',
  $nx_pid = 'UNSET',
  $nx_daemon_user = 'UNSET'
)
{
  include nginx::params

  $nx_conf_dir_real = $nx_conf_dir ? {
    'UNSET' => $::nginx::params::nx_conf_dir,
    default => $nx_conf_dir,
  }

  $nx_worker_processes_real = $nx_worker_processes ? {
    'UNSET' => $::nginx::params::nx_worker_processes,
    default => $nx_worker_processes,
  }

  $nx_worker_connections_real = $nx_worker_connections ? {
    'UNSET' => $::nginx::params::nx_worker_connections,
    default => $nx_worker_connections,
  }

  $nx_multi_accept_real = $nx_multi_accept ? {
    'UNSET' => $::nginx::params::nx_multi_accept,
    default => $nx_multi_accept,
  }

  $nx_types_hash_max_size_real = $nx_types_hash_max_size ? {
    'UNSET' => $::nginx::params::nx_types_hash_max_size,
    default => $nx_types_hash_max_size,
  }

  $nx_sendfile_real = $nx_sendfile ? {
    'UNSET' => $::nginx::params::nx_sendfile,
    default => $nx_sendfile,
  }

  $nx_keepalive_timeout_real = $nx_keepalive_timeout ? {
    'UNSET' => $::nginx::params::nx_keepalive_timeout,
    default => $nx_keepalive_timeout,
  }

  $nx_tcp_nodelay_real = $nx_tcp_nodelay ? {
    'UNSET' => $::nginx::params::nx_tcp_nodelay,
    default => $nx_tcp_nodelay,
  }

  $nx_gzip_real = $nx_gzip ? {
    'UNSET' => $::nginx::params::nx_gzip,
    default => $nx_gzip,
  }

  $nx_proxy_redirect_real = $nx_proxy_redirect ? {
    'UNSET' => $::nginx::params::nx_proxy_redirect,
    default => $nx_proxy_redirect,
  }

  $nx_proxy_set_header_real = $nx_proxy_set_header ? {
    'UNSET' => $::nginx::params::nx_proxy_set_header,
    default => $nx_proxy_set_header,
  }

  $nx_client_max_body_size_real = $nx_client_max_body_size ? {
    'UNSET' => $::nginx::params::nx_client_max_body_size,
    default => $nx_client_max_body_size,
  }

  $nx_client_body_buffer_size_real = $nx_client_body_buffer_size ? {
    'UNSET' => $::nginx::params::nx_client_body_buffer_size,
    default => $nx_client_body_buffer_size,
  }

  $nx_proxy_connect_timeout_real = $nx_proxy_connect_timeout ? {
    'UNSET' => $::nginx::params::nx_proxy_connect_timeout,
    default => $nx_proxy_connect_timeout,
  }

  $nx_proxy_send_timeout_real = $nx_proxy_send_timeout ? {
    'UNSET' => $::nginx::params::nx_proxy_send_timeout,
    default => $nx_proxy_send_timeout,
  }

  $nx_proxy_read_timeout_real = $nx_proxy_read_timeout ? {
    'UNSET' => $::nginx::params::nx_proxy_read_timeout,
    default => $nx_proxy_read_timeout,
  }

  $nx_proxy_buffers_real = $nx_proxy_buffers ? {
    'UNSET' => $::nginx::params::nx_proxy_buffers,
    default => $nx_proxy_buffers,
  }

  $nx_logdir_real = $nx_logdir ? {
    'UNSET' => $::nginx::params::nx_logdir,
    default => $nx_logdir,
  }

  $nx_pid_real = $nx_pid ? {
    'UNSET' => $::nginx::params::nx_pid,
    default => $nx_pid,
  }

  $nx_daemon_user_real = $nx_daemon_user ? {
    'UNSET' => $::nginx::params::nx_daemon_user,
    default => $nx_daemon_user,
  }


  class { 'nginx::package': }
  class { 'nginx::service': }
  class { 'nginx::config': }

  Class['nginx::package'] -> Class['nginx::config'] -> Class['nginx::service']
}
