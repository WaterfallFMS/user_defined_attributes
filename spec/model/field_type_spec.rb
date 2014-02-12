require 'spec_helper'

describe UserDefinedAttributes::FieldType do
  it 'validates model_type in the models config' do
    uda = build :user_defined_field_type, model_type: 'invalid'
    expect(uda).not_to be_valid
    expect(uda.errors.messages).to include :model_type
  end
  
  it 'validates data_type in the data_types config' do
    uda = build :user_defined_field_type, data_type: 'invalid'
    expect(uda).not_to be_valid
    expect(uda.errors.messages).to include :data_type
  end
end