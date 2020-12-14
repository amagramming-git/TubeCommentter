class StaticPagesController < ApplicationController
  def home
    per_page = 12
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: per_page)
    end
    @microposts = Micropost.page(params[:page]).per(per_page)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def help
  end

  def about
  end
end
