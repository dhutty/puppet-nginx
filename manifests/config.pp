# Class: nginx::config
#
# This module manages NGINX configuration at the top level
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class nginx::config {
  File {
    owner  => 'root',
    group  => 'root',
    mode   => 0644,
    notify => Class['nginx::service']
  }
  file { "${nginx::nx_conf_dir_real}":
    ensure => directory
  }
  file { "${nginx::nx_conf_dir_real}/conf.d":
    ensure => directory
  }
  file { "${nginx::nx_conf_dir_real}/nginx.conf":
    ensure  => file,
    content => template("nginx/nginx.conf.erb")
  }
# This file sets various defaults concerning proxies which can be overridden either in the class definition or per location
  file { "${nginx::nx_conf_dir_real}/conf.d/proxy.conf":
    ensure => file,
    content => template('nginx/proxy.conf.erb'),
  }
}
