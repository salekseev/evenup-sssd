# == Class: sssd::config
#
# This class configures sssd.  It is not intended to be called directly.
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class sssd::config {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { '/etc/sssd/sssd.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    notify  => Class['sssd::service'],
    content => template('sssd/sssd.conf.erb'),
  }

  file { '/etc/pam.d/password-auth':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
    notify => Class['sssd::service'],
    source => 'puppet:///modules/sssd/password-auth',
  }

  file { '/etc/pam.d/system-auth':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
    notify => Class['sssd::service'],
    source => 'puppet:///modules/sssd/system-auth',
  }

  file { '/etc/nsswitch.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
    notify => Class['sssd::service'],
    source => 'puppet:///modules/sssd/nsswitch.conf',
  }

  case $sssd::logsagent {
    'beaver': {
      beaver::stanza { '/var/log/sssd/sssd_LDAP.log':
        type => 'sssd',
        tags => ['sssd', 'ldap', $::disposition],
      }

      beaver::stanza { '/var/log/sssd/sssd.log':
        type => 'sssd',
        tags => ['sssd', $::disposition],
      }

      beaver::stanza { '/var/log/sssd/sssd_nss.log':
        type => 'sssd',
        tags => ['sssd', 'nss', $::disposition],
      }

      beaver::stanza { '/var/log/sssd/sssd_pam.log':
        type => 'sssd',
        tags => ['sssd', 'pam', $::disposition],
      }
    }
    default: {}
  }


}
