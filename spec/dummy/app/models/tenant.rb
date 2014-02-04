class Tenant
  def initialize
    #self.uuid ||= UUID.generate
  end

  def uuid
    @uuid
  end
  alias_method :id, :uuid
  #alias_method :current_id, :uuid

  def uuid=(uuid)
    @uuid = uuid
  end
  alias_method :self.current_id= , :uuid=

  def name
    @name
  end

  def name=(name)
    @name = name
  end

  def save!
    true
  end
end
