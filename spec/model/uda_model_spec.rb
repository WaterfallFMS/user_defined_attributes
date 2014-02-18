require 'spec_helper'

describe 'UDA model' do
  let(:subject) { create :lead }
  let(:udat)    { create :user_defined_field_type, model_type: Lead.to_s }

  context '.fields' do
    it 'should return a Hash' do
      expect(subject.fields).to be_a Hash
    end

    it 'should include all user defined types' do
      udat
      type2 = create :user_defined_field_type, model_type: Lead.to_s

      expect(subject.fields).to have_key udat.name
      expect(subject.fields).to have_key type2.name
    end

    it 'should include the user defined field values' do
      type2 = create :user_defined_field_type, model_type: Lead.to_s

      field1 = create :user_defined_field, field_type: udat,  model: subject
      field2 = create :user_defined_field, field_type: type2, model: subject

      new_subject = Lead.find(subject)
      expect(new_subject.fields[udat.name]).to eq field1.value
      expect(new_subject.fields[type2.name]).to eq field2.value
    end
  end

  context '.fields=' do
    it 'should take a hash' do
      expect {
        subject.fields = {name: 'test'}
      }.not_to raise_error
    end

    it 'should reject other types' do
      expect {
        subject.fields = Object.new
      }.to raise_error ArgumentError
    end
  end


  context '.public_fields' do
    before { udat.public = true; udat.save }

    it 'should call fields' do
      subject.should_receive(:fields)
      subject.public_fields
    end

    it 'should prune non-public fields' do
      type2 = create :user_defined_field_type, model_type: Lead.to_s, public: false

      expect(subject.public_fields).to include udat.name
      expect(subject.public_fields).to_not include type2.name
    end

    it 'should stringify values' do
      uda = create :user_defined_field, field_type: udat, model: subject

      new_subject = Lead.find(subject)

      field = new_subject.public_fields[udat.name]

      expect(field).to be_a String
      expect(field).to eq uda.value
    end

    context 'keys' do
      it 'should have underscores instead of spaces' do
        udat.name = 'with spaces'
        udat.save

        expect(subject.public_fields).to include 'with_spaces'
        expect(subject.public_fields).to_not include 'with spaces'
      end

      it 'should have only alphanumerical characters' do
        udat.name = "1good!@\#$%^&*()-=[]{}\\|:;'\",<.>/? value"
        udat.save

        expect(subject.public_fields).to_not include udat.name
        expect(subject.public_fields).to include '1good_value'
      end
    end
  end

  context 'on delete' do
    it 'should clean up its user defined fields' do
      create :user_defined_field, :field_type => udat, :model => subject

      new_subject = Lead.find(subject)
      expect(UserDefinedAttributes::Field.count).to eq 1
      expect {
        new_subject.destroy
      }.to change(UserDefinedAttributes::Field, :count).by(-1)
    end
  end

  context 'on validation' do
    before do
      subject
      #subject.save :validate => false
      udat.required = true
      udat.save
    end

    it 'tests existing values in the database' do
      expect(subject.valid?).to be_false
      expect(subject.errors[udat.name]).to include "can't be blank"
    end

    it 'should ensure set fields are valid' do
      create :user_defined_field, field_type: udat, model: subject
      new_subject = Lead.find(subject)
      expect(new_subject.valid?).to be_true

      new_subject.fields = {}
      expect(new_subject.valid?).to be_false
      expect(new_subject.errors[udat.name]).to include "can't be blank"
    end
    
    it 'should ensure that if a set field fails to save the validation is recorded' do
      udat.required = false
      udat.data_type = 'string' # force a length validation
      udat.save
      new_subject = Lead.find(subject)
      new_subject.fields = {udat.name => '-'*256}
      
      expect(new_subject.valid?).to be_false
      expect(new_subject.errors[udat.name]).to include 'is too long (maximum is 255 characters)'
    end
  end

  context 'after save' do
    before do
      create :user_defined_field, field_type: udat, model: subject
    end

    it 'should clean up user defined fields' do
      expect(UserDefinedAttributes::Field.count).to eq 1

      new_subject = Lead.find(subject)
      new_subject.fields = {}
      new_subject.save

      expect(UserDefinedAttributes::Field.count).to eq 0
    end

    it 'should update any changed values' do
      type2 = create :user_defined_field_type, model_type: Lead.to_s

      new_subject = Lead.find(subject)
      new_subject.fields = {type2.name => 'new value'}
      new_subject.save

      expect(UserDefinedAttributes::Field.count).to eq 1
      udf = UserDefinedAttributes::Field.first
      expect(udf.model).to      eq subject
      expect(udf.field_type).to eq type2
      expect(udf.value).to      eq 'new value'
    end

    it 'should not be called if fields are not set' do
      probe = mock 'probe', :each => []
      probe.should_not_receive(:destroy_all)
      subject.stub(:user_defined_fields => probe)

      subject.fields # set the cached @fields
      subject.save
    end
  end
end