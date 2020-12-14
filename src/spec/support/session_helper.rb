module SessionHelper
  
  # 8章テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end
  #9章
  # テストユーザーとしてログインする
  def log_in_as(user)
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(
      {user_id: user.id })
  end

end