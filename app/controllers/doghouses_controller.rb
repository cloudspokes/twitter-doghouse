class DoghousesController < ApplicationController
  skip_before_filter :user_authenticated, only: :index
  
  def index
    @doghouses = current_user.doghouses if current_user
  end

  def show
    @doghouse = Doghouse.find(params[:id])
  end

  def new
    @doghouse = Doghouse.new
    @following_users = current_user.get_following_users
  end

  def edit
    @doghouse = Doghouse.find(params[:id])
  end

  def create
    @doghouse = current_user.doghouses.build(params[:doghouse])
    if @doghouse.save
      redirect_to @doghouse, notice: 'Doghouse was successfully created.'
    else
      @following_users = current_user.get_following_users
      render action: "new"
    end
  end

  def update
    @doghouse = Doghouse.find(params[:id])
    if @doghouse.update_attributes(params[:doghouse])
      redirect_to @doghouse, notice: 'Doghouse was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @doghouse = Doghouse.find(params[:id])
    @doghouse.destroy
    redirect_to doghouses_url
  end
end
