class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @redirect_id = params[:redirect_id]
    @micropost = current_user.microposts.build(micropost_params)
    @redirect_video_id = @micropost.video_id
    if @micropost.save
      flash.now[:success] = "コメントが投稿できました"
      @comments = Micropost.where(video_id: @redirect_video_id)
    end
    begin
      #micropostのshowからの場合問題なく実行
      @targetmicropost = Micropost.find(params[:redirect_id])
      respond_to do |format|
        format.html { redirect_to @targetmicropost }
        format.js
      end
    rescue => error
      #youtubeのshowからの場合Micropost.findでエラーが起きこちらが実行
      respond_to do |format|
        format.html { redirect_to show_url}
        format.js
      end
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  def show
    @targetmicropost = Micropost.find(params[:id])
    @redirect_id = params[:id]
    @redirect_video_id = @targetmicropost.video_id
    #以下youtubeapi_pagesのshowとおんなじだからDRY原則をなんとかしたい。
    if logged_in?
      @microposts = current_user.feed.paginate(page: params[:page], per_page: 8)
    else
      @microposts = Micropost.page(params[:page]).per(8)
    end
    @comments = Micropost.where(video_id: @targetmicropost.video_id)
    @page = params[:page]
    respond_to do |format|
      format.html
      format.js
    end
  end
    
    
  private
    
    def micropost_params
      params.require(:micropost).permit(:content, :video_id)
    end
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
