class SessionsController < ApplicationController
  def new
  end


  def create
    #9章演習課題　ローカル変数userではなくインスタンス変数にすることでテストでassignsを使えるようにする
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      #11章
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or root_url
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
      #
    #  log_in @user
    #  params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
    #  #redirect_to @user
    #  #10章にて追加。フレンドリーフォワーディング実装
    #  redirect_back_or @user
    #user = User.find_by(email: params[:session][:email].downcase)
    #if user && user.authenticate(params[:session][:password])
      ##セッションに追加して
      #log_in user
      #9章
      #params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      ##remember user
      ##
      ##リダイレクトする。
      #redirect_to user
    else
      flash.now[:danger] = 'メールアドレス又はパスワードが誤っています'
      render 'new'
    end
  end

  #ログアウトする
  def destroy
    #9章
    #log_out
    log_out if logged_in?
    #
    redirect_to root_url
  end
end