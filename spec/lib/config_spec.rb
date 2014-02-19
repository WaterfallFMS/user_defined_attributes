require 'spec_helper'

describe UserDefinedAttributes::Config do
  let(:config) {UserDefinedAttributes::Config}
  
  it 'starts with default values' do
    expect(config.models).not_to be_nil
    expect(config.data_types).not_to be_nil
    expect(config.default_data_type).not_to be_nil
    expect(config.form_builder).not_to be_nil
  end
  
  context 'model_display' do
    it 'returns array of name value pairs' do
      display = config.models_display
      expect(display).to be_an Array
      expect(display.first).to be_an Array
      
      expect(display.first.size).to eq 2
    end
    
    it 'constantizes the object and call model_name.human to get the value' do
      name = double('model_name', human: 'foo bar')
      expect(Lead).to receive(:model_name).and_return name
      display = config.models_display.first
      
      expect(display[0]).to eq 'foo bar'
      expect(display[1]).to eq 'Lead'
    end
  end
end