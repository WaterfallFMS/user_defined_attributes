Rails.application.config.user_defined_attributes.configure do |config|
  config.models = %w(Lead)
  
  config.form_builder = :simple_form
end