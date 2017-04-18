class CompaignsController < ApplicationController
  before_action :authenticate_user!
  def new
    @compaign = Compaign.new
  end

  def create
    compaign_params = params.require(:compaign).permit(:title,
                                                       :body,
                                                       :goal,
                                                       :end_date)
    @compaign = Compaign.new compaign_params
    @compaign.user = current_user
    if @compaign.save
      redirect_to compaign_path(@compaign), notice:'Compaign created'
    else
      render :new
    end
  end

  def edit
    @compaign = Compaign.find params[:id]
    # if @compaign.user != current_user
    #   redirect_to root_path
    # end
    redirect_to root_path unless can? :edit, @compaign
  end

  def destroy
    @compaign = Compaign.find params[:id]
    @compaign.destroy
  end
end
