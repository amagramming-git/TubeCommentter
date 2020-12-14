require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe "relationshipの作成" do
    before do
      @user = create(:user,:activated)
      @otherUser = create(:user,:other)
    end
    context "正常ケース" do
      it "follower_idとollowed_idが適切に存在している" do
        relationship = build(:relationship,follower_id: @user.id,followed_id: @otherUser.id)
        relationship.valid?
        expect(relationship).to be_valid
      end
    end
    context "異常ケース" do
      it "follower_idが存在しない場合エラー" do
        relationship = build(:relationship,follower_id: "",followed_id: @otherUser.id)
        relationship.valid?
        expect(relationship.errors[:follower_id]).to include("を入力してください")
      end
      it "followed_idが存在しない場合エラー" do
        relationship = build(:relationship,follower_id: @user.id,followed_id: "")
        relationship.valid?
        expect(relationship.errors[:followed_id]).to include("を入力してください")
      end
      it "follower_idが存在しないユーザーの場合エラー" do
        user = create(:user,:michael)
        destroyedUserId = user.reload.id
        user.destroy
        relationship = build(:relationship,follower_id: destroyedUserId,followed_id: @otherUser.id)
        relationship.valid?
        expect(relationship.errors[:follower]).to include("を入力してください")
      end
      it "followed_idが存在しないユーザー場合エラー" do
        user = create(:user,:michael)
        destroyedUserId = user.reload.id
        user.destroy
        relationship = build(:relationship,follower_id: @user.id,followed_id: destroyedUserId)
        relationship.valid?
        expect(relationship.errors[:followed]).to include("を入力してください")
      end
    end
  end
end
