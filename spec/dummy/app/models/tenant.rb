# Fake a Tenant model
class Tenant
  attr_accessor :name, :uuid

  def initialize
    id
  end

  # required hook
  def id
    @id ||= next_id
  end

  def save!
    true
  end
  alias_method :save, :save!

  # required hook
  def self.current_tenant
    @tenant ||= self.new
  end

  private
  def next_id
    count = Thread.current[:tenant_count] ||= 0
    Thread.current[:tenant_count] = count + 1
  end
end
