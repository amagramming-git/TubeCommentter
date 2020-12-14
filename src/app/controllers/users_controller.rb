class UsersController < ApplicationController
  #10章　認可
  before_action :logged_in_user, only: [:index,:edit, :update,:destroy,:following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def new
    @user = User.new
  end

  #7章ユーザーの登録と照会

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 8)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      #11章有効化メールを送信する
      @user.send_activation_email
      flash[:info] = "まだ登録は完了しておりません。メールをご確認ください。"
      redirect_to root_url
      #8章登録後すぐにログインする
    else
      render 'new'
    end
  end

  #10章
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  #12章
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private
    def user_params
      #セキュリティ性を高めている。以下のパラメーターのみ許可。
      params.require(:user).permit(:name, :email, :password,
                                :password_confirmation)
    end
    #アプリケーションコントローラーに移動しました
    #def logged_in_user

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
