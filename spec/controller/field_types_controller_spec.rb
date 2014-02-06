require 'spec_helper'

describe UserDefinedAttributes::FieldTypesController, type: :controller do
  routes { UserDefinedAttributes::Engine.routes }

  controller do
    attr_accessor :auth_object, :auth_action

    def authorize(object,action=nil)
      @auth_object = object
      @auth_action = action || (params[:action].to_s + '?')
    end

    def policy_scope(object)
      # some random restriction
      object.limit(4)
    end
  end

  describe "GET index" do
    it "sorts by name" do
      objects = []
      objects.push create(:user_defined_field_type, name: 'C')
      objects.push create(:user_defined_field_type, name: 'b')
      objects.push create(:user_defined_field_type, name: 'A')
      objects.push create(:user_defined_field_type, name: '1')

      get :index
      local = assigns(:field_types)
      expect(local).to eq objects.reverse
    end

    it 'should request allowed items' do
      create_list :user_defined_field_type, 6

      get :index
      local = assigns(:field_types)
      expect(local.size).to eq 4
      expect(local).to be_an ActiveRecord::Relation
    end
  end

  describe "POST create" do
    it 'authorizes create' do
      post :create, field_type: {name: 'test'}
      expect(controller.auth_object).to be_a UserDefinedAttributes::FieldType
      expect(controller.auth_action).to eq 'create?'
    end

    it 'creates valid types' do
      udat = build :user_defined_field_type

      expect {
        post :create, field_type: udat.attributes
      }.to change(UserDefinedAttributes::FieldType, :count).by(1)
    end
  end

  describe 'PUT update' do
    let!(:udat) {create :user_defined_field_type}

    it 'authorizes update' do
      put :update, id: udat.id, field_type: {name: 'new name'}
      expect(controller.auth_object).to be_a UserDefinedAttributes::FieldType
      expect(controller.auth_action).to eq 'update?'
    end

    it 'updates valid types' do
      put :update, id: udat.id, field_type: {name: 'new name'}

      expect(UserDefinedAttributes::FieldType.find(udat.id).name).to eq 'new name'
    end
  end

  describe 'DELETE destory' do
    let!(:udat) {create :user_defined_field_type}
    let!(:field) {create :user_defined_field, field_type: udat}

    it 'destroys types and fields' do
      expect {
        delete :destroy, id: udat.id
      }.to change(UserDefinedAttributes::FieldType,:count).by(-1)

      expect(UserDefinedAttributes::Field.count).to eq 0
    end
  end
#
#    let(:model)           {UserDefinedType}
#    let(:object)          {create :user_defined_type}
#    let(:post_params)     { {:user_defined_type => attributes_for(:user_defined_type)} }
#    let(:view_variable)   {:user_defined_type}
#    let(:index_path)      {admin_user_defined_types_url}
#    let(:after_save_path) {index_path}
#    it_should_behave_like 'RESTful controller'
#
#
#    describe "GET show" do
#      let(:action) {get :show, :id => object.id.to_s}
#
#      it_should_behave_like 'an invalid action'
#    end
end
