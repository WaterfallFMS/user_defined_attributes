require 'spec_helper'

describe Lead do
  it 'can be created', focus:true do
    expect{
      Lead.create attributes_for :lead
    }.to change(Lead, :count).by 1
  end
end