require_relative '../spec_helper_acceptance'
require_relative '../support/shared_acceptance_specs'


describe 'ora_exec' do

  before do
    apply_manifest(<<-EOS)
      ora_user{'valid_user':
        ensure   => 'present',
        password => 'valid_user',
      }
    EOS
  end

  context 'with a valid username and password' do
    it "executes the query" do
      apply_manifest(<<-EOS, :expect_changes => true)
        ora_exec{'select * from tab':
          username => 'valid_user',
          password => 'valid_user',
        }
      EOS
    end

  end

  #
  # TODO: Fix the type so this fails
  # context 'with an invalid username and password' do
  #   it "fails to execute" do
  #     apply_manifest(<<-EOS, :expect_failures => true)
  #       ora_exec{'select * from tab':
  #         username => 'invalid_user',
  #         password => 'invalid_user',
  #       }
  #   EOS
  #   end

  # end

  context 'without a username and password' do

    context "with a invalid sql query" do
      it "fails to execute" do
        apply_manifest(<<-EOS, :expect_failures => true)
          ora_exec{'invalid sql statement':}
        EOS
      end
    end


    context "with a valid sql query" do

      context "without an unless query"
        it "executes the query" do
          apply_manifest(<<-EOS, :expect_changes => true)
            ora_exec{'select * from tab':}
          EOS
        end
      end

      context "with an empty unless query" do
        it "doesn't execute the named query" do
          apply_manifest(<<-EOS, :expect_changes => true)
            ora_exec{'select * from tab':
              unless => "select * from dual where dummy = 'A'",
            }
          EOS
        end
      end

      context "with an non-empty unless query" do
        it "execute's the named query" do
          apply_manifest(<<-EOS, :expect_changes => false)
            ora_exec{'select * from tab':
              unless => "select * from dual where dummy = 'X'",
            }
          EOS
        end
      end

  end


end
