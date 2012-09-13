# Class: nginx::package
#
# This module manages NGINX package installation
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
class nginx::package {
  case downcase($::operatingsystem) {
    centos,fedora,rhel: {
      class {'nginx::package::redhat': }
    }
    debian, ubuntu: {
      class {'nginx::package::debian': }
    }
  }
}
