module UserDefinedAttributes
  class FieldTypesController < ::ApplicationController
    before_action :new_type,        only: [:new, :create]
    before_action :find_type,       only: [:edit, :update]
    before_action :clean_data_type, only: [:create, :update]

    def index
      @field_types = policy_scope(FieldType).sorted
    end

    def new
    end

    def edit
    end

    def create
      @field_type = FieldType.new field_type_params
      authorize @field_type

      if @field_type.save
        redirect_to :field_types
      else
        render action: 'new'
      end
    end

    def update
      @field_type = FieldType.find(params[:id])
      authorize @field_type

      if @field_type.update_attributes(field_type_params)
        redirect_to :field_types
      else
        render action: 'edit'
      end
    end

    def destroy
      @field_type = FieldType.find(params[:id])
      @field_type.destroy

      redirect_to :field_types
    end

    private
    def field_type_params
      params.require(:field_type).permit(:tenant_id, :name, :model_type, :data_type, :required, :public, :hidden)
    end

    def new_type
      @field_type = FieldType.new
      @field_type.assign_attributes field_type_params if params[:action] == 'create'
      authorize @field_type
    end

    def find_type
      @field_type = FieldType.find(params[:id])
      authorize @field_type
    end

    def clean_data_type
      # force data type to a known value
      params.fetch(:field_type,{})['data_type'] = 'string'
    end
  end
end
