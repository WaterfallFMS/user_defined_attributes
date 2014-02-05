RSpec.configure do |config|
  config.before(:each) do |test|
    unless example.metadata[:skip_tenant]
      @global_tenant    = create(:tenant)
      Tenant.current_id = @global_tenant.id
    end
  end
end
