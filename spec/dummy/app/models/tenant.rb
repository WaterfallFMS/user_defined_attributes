# Fake a Tenant model
class Tenant
  include TenantContainer

  attr_accessor :name, :uuid

  def id
    @id ||= next_id
  end

  def save!
    true
  end

  private
  def next_id
    count = Thread.current[:tenant_count] ||= 0
    Thread.current[:tenant_count] = count
  end
end
