class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_url( @user )
      flash[:success] = "Welcome to the Sample App!"
    else
    render 'new'
    end
  end
 
  def show
    @user = User.find(params[:id])
    #debugger placing this makes it possible to inspect the code at runtime. this could be useful for finding bugs
  end 
  private 
    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                   :password_confirmation)
    end
end
