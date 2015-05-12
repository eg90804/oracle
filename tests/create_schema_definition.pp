ora_schema_definition{'app@test':
  ensure      => '2.3.0',
  source_path => '/vagrant',
  parameters => {
    app_data_tablespace  => 'USERS',
    app_index_tablespace => 'USERS',
  }
}
