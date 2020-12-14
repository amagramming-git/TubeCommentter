module ApplicationHelper
  # ページごとの完全なタイトルを返します。                   # コメント行
  def full_title(page_title = '')                     # メソッド定義とオプション引数
    base_title = ConstantHelper::THE_WEB_SITE_NAME  # 変数への代入
    if page_title.empty?                              # 論理値テスト
      base_title                                      # 暗黙の戻り値
    else 
      page_title + "-" + base_title                 # 文字列の結合
    end
  end

  def get_the_web_site_name
    base_title = ConstantHelper::THE_WEB_SITE_NAME
  end

  def root_path?
    request.path_info == root_path
  end


end
