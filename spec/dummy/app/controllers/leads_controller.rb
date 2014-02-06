class LeadsController < ApplicationController
  helper 'user_defined_attributes/uda'

  def index
  end

  def show
    @lead = Lead.find(params[:id])
  end

  def new
    @lead = Lead.new
  end

  def edit
    @lead = Lead.find(params[:id])
  end

  def create
    @lead = Lead.new lead_params

    if @lead.save
      redirect_to @lead
    else
      render action: 'new'
    end
  end

  def update
    @lead = Lead.find params[:id]

    if @lead.update_attributes lead_params
      redirect_to @lead
    else
      render action: 'edit'
    end
  end

  private
  def lead_params
    params.require(:lead).permit(:name, Lead.uda_strong_params)
  end
end