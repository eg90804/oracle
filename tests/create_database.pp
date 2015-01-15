ora_database{'bert':
  ensure            => present,
  # instances         => {bert1 => 'db'},
  oracle_base       => '/opt/oracle',
  oracle_home       => '/opt/oracle/app/11.04',
  control_file      => 'reuse',
  create_catalog    => 'no',
  extent_management => 'local',
  logfile_groups => [
      {file_name => 'test1.log', size => '50M', reuse => true},
      {file_name => 'test2.log', size => '50M', reuse => true},
    ],
  default_tablespace => {
    name      => 'USERS',
    datafile  => {
      file_name  => 'users.dbs',
      size       => '50M',
      reuse      =>  true,
    },
    extent_management => {
      type          => 'local',
      autoallocate  => true,
    }
  },
  datafiles       => [
    {file_name   => 'file1.dbs', size => '50M', reuse => true},
    {file_name   => 'file2.dbs', size => '50M', reuse => true},
  ],
  default_temporary_tablespace => {
    name      => 'TEMP',
    type      => 'bigfile',
    tempfile  => {
      file_name  => 'tmp.dbs',
      size       => '50M',
      reuse      =>  true,
      autoextend => {
        next    => '10M',
        maxsize => 'unlimited',
      }
    },
    extent_management => {
      type          => 'local',
      uniform_size  => '10M',
    },
  },
  undo_tablespace   => {
    name      => 'UNDOTBS',
    type      => 'bigfile',
    datafile  => {
      file_name  => 'undo.dbs',
      size       => '50M',
      reuse      =>  true,
    }
  },
  sysaux_datafiles => [
    {file_name   => 'sysaux1.dbs', size => '50M', reuse => true},
    {file_name   => 'sysaux2.dbs', size => '50M', reuse => true},
  ]
}
