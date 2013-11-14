# Class: nginx::service
#
# This module manages the NGINX service and rebuilds vhost config
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
# TODO:
#
# The exec in this class should probably have an onlyif attribute to ensure that it only rebuilds the generated config and refreshes the service if the fragments have changed
#
# This class file is not called directly
class nginx::service {
  Exec['compile-nginx-config'] -> Service['nginx']
  exec { 'compile-nginx-config':
    command     => "/bin/cat ${nginx::nx_conf_dir_real}/conf.d/.frag* > ${nginx::nx_conf_dir_real}/conf.d/generated.conf",
    #onlyif => "",
    refreshonly => true,
  }
  service { 'nginx':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true
  }
}
