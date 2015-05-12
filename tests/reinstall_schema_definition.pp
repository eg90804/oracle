ora_schema_definition{'app@test':
  ensure      => '2.4.0',
  source_path => '/vagrant',
  reinstall   => true,
  parameters => {
    app_data_tablespace  => 'USERS',
    app_index_tablespace => 'USERS',
  }
}
