require 'spec_helper'

describe 'UserDefinedAttributes' do
  describe UserDefinedAttributes::UserDefinedTypesController do
    login_as :superadmin

    describe "GET index" do
      it "sorts by name" do
        objects = []
        objects.push create(:user_defined_type, :name => 'C')
        objects.push create(:user_defined_type, :name => 'b')
        objects.push create(:user_defined_type, :name => 'A')
        objects.push create(:user_defined_type, :name => '1')

        get :index
        assigns(:user_defined_types).should eq objects.reverse
      end
    end

    describe "POST create" do
      # these are limiting tests that exist to ensure that we can't abuse features we are adding later.
      it 'should set model type to "Franchise"' do
        post :create, :user_defined_type => {:name => 'foo', :model_type => 'bar'}

        u = UserDefinedType.last
        u.name.should == 'foo'
        u.model_type.should == 'Franchise'
      end

      it 'should set data type to "text"' do
        post :create, :user_defined_type => {:name => 'foo', :data_type => 'bar'}

        u = UserDefinedType.last
        u.name.should == 'foo'
        u.data_type.should == 'text'
      end
    end

    let(:model)           {UserDefinedType}
    let(:object)          {create :user_defined_type}
    let(:post_params)     { {:user_defined_type => attributes_for(:user_defined_type)} }
    let(:view_variable)   {:user_defined_type}
    let(:index_path)      {admin_user_defined_types_url}
    let(:after_save_path) {index_path}
    it_should_behave_like 'RESTful controller'


    describe "GET show" do
      let(:action) {get :show, :id => object.id.to_s}

      it_should_behave_like 'an invalid action'
    end
  end
end
