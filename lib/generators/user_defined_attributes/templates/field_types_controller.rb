module UserDefinedAttributes
  class FieldTypesController < ApplicationController
    helper Rails.application.routes.url_helpers

    before_action :new_type,        only: [:new, :create]
    before_action :find_type,       only: [:edit, :update, :destroy]

    def index
      @user_defined_attributes_field_types = policy_scope(FieldType).sorted
    end

    def new
    end

    def edit
    end

    def create
      if @user_defined_attributes_field_type.save
        redirect_to :user_defined_attributes_field_types
      else
        render action: 'new'
      end
    end

    def update
      if @user_defined_attributes_field_type.update_attributes(field_type_params)
        redirect_to :user_defined_attributes_field_types
      else
        render action: 'edit'
      end
    end

    def destroy
      @user_defined_attributes_field_type.destroy

      redirect_to :user_defined_attributes_field_types
    end

    private
    def field_type_params
      params.require(:field_type).permit(:tenant_id, :name, :model_type, :data_type, :required, :public, :hidden)
    end

    def new_type
      @user_defined_attributes_field_type = FieldType.new
      @user_defined_attributes_field_type.assign_attributes field_type_params if params[:action] == 'create'
      authorize @user_defined_attributes_field_type
    end

    def find_type
      @user_defined_attributes_field_type = FieldType.find(params[:id])
      authorize @user_defined_attributes_field_type
    end
  end
end
