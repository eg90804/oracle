$user_rights        = ['CONNECT'
                      , 'CREATE TABLE'
                      , 'CREATE TRIGGER'
                      , 'CREATE TYPE'
                      , 'CREATE VIEW'
                      , 'CREATE SEQUENCE'
                      , 'QUERY REWRITE'
                      , 'CREATE PROCEDURE'
                      , 'SELECT_CATALOG_ROLE'
]


ora_user{'APP':
  ensure    => present,
  password  => 'APP',
  grants    => [$user_rights],
  quotas    => {"USERS"  => 'unlimited'},  
}
