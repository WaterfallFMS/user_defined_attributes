require 'spec_helper'

describe Lead do
  let(:subject) {create :lead}
  before do
    @type = create :user_defined_field_type, :model_type => Lead.to_s
  end

  it 'can be created' do
    expect{
      Lead.create attributes_for :lead
    }.to change(Lead, :count).by 1
  end

  it 'should whitelist the fields attribute' do
    subject.update_attributes :fields => {@type.name => 'foo'}
    expect(subject.fields[@type.name]).to eq 'foo'
  end

  context '.fields' do
    it 'should return a Hash' do
      expect(subject.fields).to be_a Hash
    end

    it 'should include all user defined types' do
      type2 = create :user_defined_field_type, :model_type => Lead.to_s

      expect(subject.fields).to have_key @type.name
      expect(subject.fields).to have_key type2.name
    end

    it 'should include the user defined field values' do
      type2 = create :user_defined_field_type, :model_type => Lead.to_s

      field1 = create :user_defined_field, :field_type => @type, :model => subject
      field2 = create :user_defined_field, :field_type => type2, :model => subject

      new_subject = Lead.find(subject)
      expect(new_subject.fields[@type.name]).to eq field1.value
      expect(new_subject.fields[type2.name]).to eq field2.value
    end
  end

  context '.public_fields' do
    it 'should call fields' do
      subject.should_receive(:fields)
      subject.public_fields
    end

    it 'should prune non-public fields' do
      @type.name = 'first'; @type.save
      type2 = create :user_defined_field_type, :name => 'second', :model_type => Lead.to_s, :public => true

      expect(subject.public_fields).to include type2.name
      expect(subject.public_fields).to_not include @type.name
    end

    it 'should stringify values' do
      @type.name = 'first'; @type.public = true; @type.save
      field = create :user_defined_field, :field_type => @type, :model => subject

      new_subject = Lead.find(subject)
      expect(new_subject.public_fields[@type.name]).to be_a String
      expect(new_subject.public_fields[@type.name]).to eq field.value
    end

    context 'keys' do
      before {@type.public = true; @type.save}

      it 'should have underscores instead of spaces' do
        @type.name = 'with spaces'
        @type.save

        expect(subject.public_fields).to include 'with_spaces'
        expect(subject.public_fields).to_not include 'with spaces'
      end

      it 'should have only alphanumerical characters' do
        @type.name = "1good!@\#$%^&*()-=[]{}\\|:;'\",<.>/? value"
        @type.save

        expect(subject.public_fields).to_not include @type.name
        expect(subject.public_fields).to include '1good_value'
      end
    end
  end

  context '.fields=' do
    it 'should take a hash' do
      expect {
        subject.fields = {:name => 'test'}
      }.not_to raise_error
    end

    it 'should reject other types' do
      expect {
        subject.fields = Object.new
      }.to raise_error ArgumentError
    end
  end

  context 'on delete' do
    it 'should clean up its user defined fields' do
      create :user_defined_field, :field_type => @type, :model => subject

      new_subject = Lead.find(subject)
      expect(UserDefinedAttributes::Field.count).to eq 1
      expect {
        new_subject.destroy
      }.to change(UserDefinedAttributes::Field, :count).by(-1)
    end
  end

  context 'before validation' do
    before do
      subject.save :validate => false
      @type.required = true
      @type.save
    end

    it 'tests existing values in the database' do
      expect(subject.valid?).to be_false
      expect(subject.errors[@type.name]).to include "can't be blank"
    end

    it 'should ensure set fields are valid' do
      create :user_defined_field, :field_type => @type, :model => subject
      new_subject = Lead.find(subject)
      expect(new_subject.valid?).to be_true

      new_subject.fields = {}
      expect(new_subject.valid?).to be_false
      expect(new_subject.errors[@type.name]).to include "can't be blank"
    end
  end

  context 'after save' do
    before do
      create :user_defined_field, :field_type => @type, :model => subject
    end

    it 'should clean up user defined fields' do
      expect(UserDefinedAttributes::Field.count).to eq 1

      new_subject = Lead.find(subject)
      new_subject.fields = {}
      new_subject.save

      expect(UserDefinedAttributes::Field.count).to eq 0
    end

    it 'should update any changed values' do
      type2 = create :user_defined_field_type, :model_type => Lead.to_s

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