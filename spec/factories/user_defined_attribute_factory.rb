FactoryGirl.define do
  factory :user_defined_field_type, class: UserDefinedAttributes::FieldType do
    sequence(:name) {|n| "UDA#{ "%03d" % n }" }
    model_type      'Lead'
    data_type       'string'
    required        false
  end

  factory :user_defined_field, class: UserDefinedAttributes::Field do
    association :field_type

    sequence(:value) {|n| "#{field_type.name} value #{n}"}
  end
end
