# Copied from Waterfall
module TenantContainer
  extend ActiveSupport::Concern

  module ClassMethods
    def current_id=(id)
      Thread.current[:tenant_id] = id
    end

    def current_id
      Thread.current[:tenant_id]
    end

    def with_id(id_or_object)
      old = current_id
      new = id_or_object.respond_to?(:id) ? id_or_object.id : id_or_object.to_i

      self.current_id = new
      yield
    ensure
      self.current_id = old
    end

    def current
      self.find(current_id)
    rescue ActiveRecord::RecordNotFound => e
      # raise a new exception so that we can catch and deal with it
      raise Tenant::TenantNotFoundError, e.to_s, e.backtrace
    end
  end
end