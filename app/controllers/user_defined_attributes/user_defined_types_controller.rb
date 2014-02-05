module UserDefinedAttributes
  class UserDefinedTypesController < ApplicationController
    #load_and_authorize_resource
    before_filter :clean_params, :only => [:create,:update]

    def index
      @user_defined_types = @user_defined_types.default_sort.paginate(:page => params[:page])
    end

    def new
    end

    def edit
    end

    def create
      if @user_defined_type.save
        redirect_to(admin_user_defined_types_path, :notice => t('messages.model_created', :model => UserDefinedType.model_name.human))
      else
        flash_errors_for @user_defined_type
        render :action => "new"
      end
    end

    def update
      if @user_defined_type.update_attributes(params[:user_defined_type])
        redirect_to(admin_user_defined_types_path, :notice => t('messages.model_updated', :model => UserDefinedType.model_name.human))
      else
        flash_errors_for @user_defined_type
        render :action => "edit"
      end
    end

    def destroy
      @user_defined_type.destroy

      redirect_to admin_user_defined_types_path, :notice => t('messages.model_deleted', :model => UserDefinedType.model_name.human)
    end

    private
    def clean_params
      # note this only exists until we can support more then one user defined type
      uda = params[:user_defined_type] || {}
      uda.delete :model_type
      uda.delete :data_type

      @user_defined_type.model_type = nil
      @user_defined_type.data_type  = nil
    end
  end
end
