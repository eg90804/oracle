ora_database{'bert':
  ensure          => present,
  oracle_base     => '/opt/oracle',
  oracle_home     => '/opt/oracle/app/11.04',
  control_file    => 'reuse',
  create_catalog  => 'no',
}
