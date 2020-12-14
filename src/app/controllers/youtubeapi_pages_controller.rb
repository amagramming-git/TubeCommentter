#youtubeAPIを使用する場合は以下のものをrequireしてください
require 'google/apis/youtube_v3'
require 'active_support/all'

class YoutubeapiPagesController < ApplicationController

  def search
    after = nil
    before = Time.now
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV.fetch("GOOGLE_API_KEY")
    opt = {
      q: params[:keyword],
      type: 'video',
      region_code: 'JP',
      max_results: 8,
      order: nil,
      page_token: params[:page_token],
      published_after: nil,
      published_before: before.iso8601
    }
    results = service.list_searches(:snippet, opt)
    @next_page_token = results.next_page_token
    @prev_page_token = results.prev_page_token
    @keyword = params[:keyword]

    #ものすごく長ったらしいけど、Json形式のファイルを掘っていくやり方を知らないだけ...
    #返ってきた値から必要なデータを抽出してyoutubeインスタンスに入れているだけです。
    @youtubes = Array.new
    results.items.each do |item|
      id = item.id
      snippet = item.snippet
      thumbnails = snippet.thumbnails
      thumbnail =thumbnails.high
      channelList = service.list_channels(:snippet, id: snippet.channel_id)
      channelItems = channelList.items
      channelItem = channelItems.first
      channelSnippet = channelItem.snippet
      channelThumbnails = channelSnippet.thumbnails
      channelDefault = channelThumbnails.default
      channelIconUrl = channelDefault.url
      youtube = Youtube.new
      youtube.video_id = id.video_id
      youtube.thumbnail = thumbnail.url
      youtube.channel_id = snippet.channel_id
      youtube.channel_icon = channelIconUrl
      youtube.channel_title = snippet.channel_title
      youtube.description = snippet.description
      youtube.published_at = snippet.published_at
      youtube.title = snippet.title
      @youtubes.push(youtube)
    end
  end

  def show 
    @targetYoutube = Youtube.new
    @targetYoutube.video_id = params[:video_id]
    @redirect_video_id = params[:video_id]
    @redirect_id = nil
    #以下microposts_controllerのShowメソッドとほとんど同じなので、なんとかDRY原則を当てはめたい。
    if logged_in?
      @microposts = current_user.feed.paginate(page: params[:page], per_page: 8)
    else
      @microposts = Micropost.page(params[:page]).per(8)
    end
    @comments = Micropost.where(video_id: @targetYoutube.video_id)
    @page = params[:page]
    respond_to do |format|
      format.html
      format.js
    end
  end



end
