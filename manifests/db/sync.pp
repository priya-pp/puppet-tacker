#
# Class to execute "tacker-manage db_sync
#
class tacker::db::sync(
  $extra_params = '--config-file /etc/tacker/tacker.conf',
){


  Tacker_config<||> ~> Exec['tacker-db-sync']

  exec { 'tacker-db-sync':
    command     => "tacker-db-manage ${extra_params} upgrade head",
    path        => '/usr/bin',
    refreshonly => true,
    logoutput   => on_failure,
    subscribe   => [Package['tacker'], Tacker_config['database/connection']],
    require     => User['tacker'],
  }

  Exec['tacker-db-sync'] ~> Service<| title == 'tacker' |>
}
