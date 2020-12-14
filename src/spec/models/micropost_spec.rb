require 'rails_helper'

RSpec.describe Micropost, type: :model do
  describe "マイクロポストの投稿" do
    before do
      @user = create(:user,:activated)
    end

    context "正常ケース" do
      it "ユーザーに紐付けてmicropostを追加することができる" do
        micropost = build(:micropost, user_id: @user.id)
        micropost.valid?
        expect(micropost).to be_valid
      end
      it "contentは最大140文字まで" do
        micropost = build(:micropost, user_id: @user.id,content: "a"*140)
        micropost.valid?
        expect(micropost).to be_valid
      end
      it "micropostは投稿時間の降順で並んでいる" do
        firstMicropost = create(:micropost,:first, user_id: @user.id)
        secondMicropost = create(:micropost,:second, user_id: @user.id)
        thirdMicropost = create(:micropost,:third, user_id: @user.id)
        thirdMicropost.reload
        micropost = Micropost.first
        expect(micropost.id).to eq thirdMicropost.id
      end
    end

    context "異常ケース" do
      it "ユーザーIDが存在しない場合エラー" do
        micropost = build(:micropost, user_id: "")
        micropost.valid?
        expect(micropost.errors[:user_id]).to include("を入力してください")
      end
      it "contentが存在しない場合エラー" do
        micropost = build(:micropost, content: "")
        micropost.valid?
        expect(micropost.errors[:content]).to include("を入力してください")
      end
      it "contentが空欄の場合エラー" do
        micropost = build(:micropost, content: "      ")
        micropost.valid?
        expect(micropost.errors[:content]).to include("を入力してください")
      end
      it "video_idが存在しない場合エラー" do
        micropost = build(:micropost, video_id: "")
        micropost.valid?
        expect(micropost.errors[:video_id]).to include("を入力してください")
      end
      it "存在しないユーザーIDの場合エラー" do
        #他のユーザーを一度作成したのちに削除することで使用されていないUserIDを取得する
        otherUser = build(:user,:other)
        otherUser.save
        otherUser.reload
        destroyedUserId = otherUser.id
        otherUser.destroy
        micropost = build(:micropost, user_id: destroyedUserId)
        micropost.save
        expect(micropost.errors[:user]).to include("を入力してください")
      end
      it "contentが最大文字数140を超えた場合エラー" do
        micropost = build(:micropost, content: "a" * 141)
        micropost.valid?
        expect(micropost.errors[:content]).to include("は140文字以内で入力してください")
      end
    end
  end
end
