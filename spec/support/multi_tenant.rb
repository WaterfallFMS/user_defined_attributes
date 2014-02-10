RSpec.configure do |config|
  config.before(:each) do |test|
    unless example.metadata[:skip_tenant]
      Tenant.current_tenant
    end
  end
end
