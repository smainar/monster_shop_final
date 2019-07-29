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

  def address_params
    params.require(:address).permit(:nickname, :street, :city, :state, :zip)
  end
end