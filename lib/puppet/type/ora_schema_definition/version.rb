class Version
  include Comparable

  def initialize( version)
    @version = version
  end

  def <=>( other_version)
    my_version    = translate_version(@version)
    other_version = translate_version(other_version)
    my_version <=> other_version
  end

  private

  def translate_version(version)
    case version
    when 'latest', :latest
      '999.999.999'
    when 'absent', :absent
       '000.000.000'
     else
      version
    end
  end

  def to_s
    @version
  end
      
end