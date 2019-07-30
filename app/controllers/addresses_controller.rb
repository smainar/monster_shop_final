class AddressesController < ApplicationController
  def new
    @user = current_user
    @address = Address.new
  end

  def create
    @user = current_user
    @address = @user.addresses.new(address_params)
    if @address.save
      redirect_to profile_path
      flash[:success] = "Your address at #{@address.street} was created."
    else
      flash[:error] = @address.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @user = current_user
    @address = Address.find(params[:id])
  end

  def update
    @user = current_user
    @address = Address.find(params[:id])
    if @address.update!(address_params)
      flash[:success] = "Address was updated!"
      redirect_to profile_path
    else
      flash[:error] = @address.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @address = Address.find(params[:id])
    if @address.user_id == current_user.id
      @address.destroy
      flash[:success] = "Address was deleted!"
      redirect_to profile_path
    end
  end

  def address_params
    params.require(:address).permit(:nickname, :street, :city, :state, :zip, :user_id)
  end
end
