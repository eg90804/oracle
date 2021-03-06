require_relative '../spec_helper_acceptance'
require_relative '../support/shared_acceptance_specs'


describe 'ora_tablespace' do

  it_behaves_like "an ensurable resource", {
    :resource_name      => 'ora_tablespace',
    :present_manifest   => <<-EOS,

    ora_tablespace{test: 
      ensure    =>'present',
      datafile  => 'test.dbf', 
      logging   =>'yes', 
      size      => '5M',
    }

    EOS
    :change_manifest   => <<-EOS,

    ora_tablespace{test: 
      ensure    =>'present',
      datafile  => 'test.dbf', 
      logging   =>'no', 
      size      => '5M',
    }

    EOS
    :absent_manifest    => <<-EOS,
    ora_tablespace{test: 
      ensure    =>'absent',
    }
    EOS
  }

  context 'changing the autoexend properties' do
    #
    # Tests for changing auto extend properties
    #
    it_behaves_like "an ensurable resource", {
      :resource_name      => 'ora_tablespace',
      :present_manifest   => <<-EOS,

      ora_tablespace{test: 
          ensure             => 'present',
          datafile           => 'test2.dbf',
          contents           => permanent,
          bigfile            => 'yes',
          size               => 5M,
          logging            => 'yes',
          autoextend         => 'off',
        }

      EOS
      :change_manifest   => <<-EOS,

      ora_tablespace{test: 
          ensure             => 'present',
          datafile           => 'test2.dbf',
          contents           => permanent,
          bigfile            => 'yes',
          size               => 5M,
          logging            => 'yes',
          autoextend         => 'on',
          next               => 1M,
          max_size           => 10M,
        }

      EOS
      :absent_manifest    => <<-EOS,
      ora_tablespace{test: 
        ensure    =>'absent',
      }
      EOS
    }
  end

end
