require 'spec_helper'

describe UserDefinedAttributes::Field do
  it 'can be created', focus:true do
    expect{UserDefinedAttributes::Field.create}.to change(UserDefinedAttributes::Field, :count).by 1
  end
end