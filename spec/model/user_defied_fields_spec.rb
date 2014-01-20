require 'spec_helper'

describe UserDefinedFields do
  it 'can be created' do
    expect{ UserDefinedFields.create}.to change(UserDefinedFields, :count).by 1
  end
end