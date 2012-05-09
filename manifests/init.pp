class atop {

  package { 'atop':
    ensure => installed;
  }

  service { 'atop':
    ensure    => running,
    enable    => true,
    subscribe => [File['/etc/sysconfig/atop'], File['/usr/bin/atopd']];
  }

  File {
    owner   => root,
    group   => root,
    require => Package['atop'],
  }

  # add new setting to configure log retention
  file { '/etc/sysconfig/atop':
    ensure => present,
    source => 'puppet://puppet.apidb.org/atop/sysconfig';
  }

  # https://bugzilla.redhat.com/show_bug.cgi?id=609124
  # also modified to delete old logs
  file { '/usr/bin/atopd':
    ensure => present,
    mode   => '0755',
    source => 'puppet://puppet.apidb.org/atop/atopd';
  }

  # https://bugzilla.redhat.com/show_bug.cgi?id=445174
  file { '/etc/cron.d/atop':
    ensure => present,
    source => 'puppet://puppet.apidb.org/atop/cron';
  }

  # https://bugzilla.redhat.com/show_bug.cgi?id=445174
  file { '/etc/cron.daily/atop':
    ensure => absent;
  }

  # https://bugzilla.redhat.com/show_bug.cgi?id=542598
  # /usr/bin/atopd (called via init script which is called via cron)
  # takes care of daily rotation and expiration of logs
  file { '/etc/logrotate.d/atop':
    ensure => absent;
  }

}
