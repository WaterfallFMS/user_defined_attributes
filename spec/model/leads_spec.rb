require 'spec_helper'

describe Lead do
  let(:subject) {Lead.new}
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
    subject.fields[@type.name].should == 'foo'
  end

  context '.fields' do
    it 'should return a Hash' do
      subject.fields.should be_a Hash
    end

    it 'should include all user defined types' do
      type2 = create :user_defined_field_type, :model_type => Lead.to_s

      subject.fields.should have_key @type.name
      subject.fields.should have_key type2.name
    end

    it 'should include the user defined field values', focus: true do
      type2 = create :user_defined_field_type, :model_type => Lead.to_s
      subject.save

      field1 = create :user_defined_field, :field_type => @type, :model => subject
      field2 = create :user_defined_field, :field_type => type2, :model => subject


      subject.fields[@type.name].should == field1.value
      subject.fields[type2.name].should == field2.value
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

      subject.public_fields.should include type2.name
      subject.public_fields.should_not include @type.name
    end

    it 'should stringify values' do
      @type.name = 'first'; @type.public = true; @type.save
      subject.save
      field = create :user_defined_field, :user_defined_field_type => @type, :model => subject

      subject.public_fields[@type.name].should be_a String
      subject.public_fields[@type.name].should == field.value
    end

    context 'keys' do
      before {@type.public = true; @type.save}

      it 'should have underscores instead of spaces' do
        @type.name = 'with spaces'
        @type.save

        subject.public_fields.should include 'with_spaces'
        subject.public_fields.should_not include 'with spaces'
      end

      it 'should have only alphanumerical characters' do
        @type.name = "1good!@\#$%^&*()-=[]{}\\|:;'\",<.>/? value"
        @type.save

        subject.public_fields.should_not include @type.name
        subject.public_fields.should include '1good_value'
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
      subject.save
      create :user_defined_field, :user_defined_field_type => @type, :model => subject

      UserDefinedField.count.should == 1
      expect {
        subject.destroy
      }.to change(UserDefinedField, :count).by(-1)
    end
  end

  context 'before validation' do
    before do
      subject.save :validate => false
      @type.required = true
      @type.save
    end

    it 'tests existing values in the database' do
      subject.valid?.should be_false
      subject.errors[@type.name].should include "can't be blank"
    end

    it 'should ensure set fields are valid' do
      create :user_defined_field, :user_defined_field_type => @type, :model => subject
      subject.valid?.should be_true

      subject.fields = {}
      subject.valid?.should be_false
      subject.errors[@type.name].should include "can't be blank"
    end
  end

  context 'after save' do
    before do
      subject.save
      create :user_defined_field, :user_defined_field_type => @type, :model => subject
    end

    it 'should clean up user defined fields' do
      UserDefinedField.count.should == 1

      subject.fields = {}
      subject.save

      UserDefinedField.count.should == 0
    end

    it 'should update any changed values' do
      type2 = create :user_defined_field_type, :model_type => Lead.to_s

      subject.fields = {type2.name => 'new value'}
      subject.save

      UserDefinedField.count.should == 1
      udf = UserDefinedField.first
      udf.model.should             == subject
      udf.user_defined_field_type.should == type2
      udf.value.should             == 'new value'
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