# define: nginx::resource::upstream
#
# This definition creates a new upstream proxy entry for NGINX
#
# Parameters:
# [*ensure*] - Enables or disables the specified location (present|absent)
# [*members*] - Array of member URIs for NGINX to connect to. Must follow valid NGINX syntax. Can include server parameters such as 'weight='.
#
# Actions:
#
# Requires:
#
# Sample Usage:
# nginx::resource::upstream { 'appproxy':
# ensure => present,
# members => [
# 'localhost:3000 weight=1',
# 'unix:/var/run/appserver.sock weight=10',
# 'otherserver.example.com:8080 backup',
# ],
# }
define nginx::resource::upstream (
  $members,
  $ensure = 'present'
) {
  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Class['nginx::service']
  }

  file { "${nginx::nx_conf_dir_real}/conf.d/${name}-upstream.conf":
    ensure => $ensure ? {
      'absent' => absent,
      default  => 'file',
    },
    content => template('nginx/upstream.erb'),
    notify  => Class['nginx::service'],
  }
}
