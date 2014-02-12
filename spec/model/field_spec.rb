require 'spec_helper'

describe UserDefinedAttributes::Field do
  it 'validates string length' do
    field = build :user_defined_field
    type = field.field_type
    type.data_type = 'string'; type.save
    
    field.value = '-'*256
    
    expect(field).not_to be_valid
    expect(field.errors.messages).to include :value
  end
  
  it 'does not validate text length' do
    field = build :user_defined_field
    type = field.field_type
    type.data_type = 'text'; type.save
    
    field.value = '-'*256
    
    expect(field).to be_valid
  end
end