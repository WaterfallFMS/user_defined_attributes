Rails.application.config.user_defined_attributes.configure do |config|
  # provide an array of the class names that can have user defined attributes attached
  config.models = %w(User)
  
  # uncomment this to provide only limited data types
  # config.data_types = [:string, :text]
  
  # uncomment this to change the default data type
  # config.default_data_type = :string
  
  # uncomment this if the form template used should be for SimpleForm
  #config.form_builder = :simple_form
end