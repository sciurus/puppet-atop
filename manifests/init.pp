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

  file { '/etc/sysconfig/atop':
    ensure => present,
    source => 'puppet://puppet.apidb.org/atop/sysconfig';
  }

  # https://bugzilla.redhat.com/show_bug.cgi?id=609124
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
  # script in /etc/cron.d takes care of rotation
  file { '/etc/logrotate.d/atop':
    ensure => absent;
  }

}
