require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'ユーザー仮登録' do
    context "正常ケース" do
      it "name email password password_confirmation が適切に存在している" do
        user = build(:user)
        expect(user).to be_valid
      end
      it "name email password password_confirmation が適切に存在している場合に保存すると有効化されていない状態で登録されること" do
        user = build(:user)
        user.save
        expect(user.reload.activated).to eq false
      end
      it "nameは最大20文字まで" do
        user = build(:user, name: "a" * 20)
        user.valid?
        expect(user).to be_valid
      end
      it "emailは最大255文字まで" do
        user = build(:user, email: "a" * 243 + "@example.com")
        user.valid?
        expect(user).to be_valid
      end
      it "passwordは最小6文字まで" do
        user = build(:user, password: "a" * 6, password_confirmation: "a" * 6)
        user.valid?
        expect(user).to be_valid
      end
      it "passwordは最大16文字まで" do
        user = build(:user, password: "a" * 16, password_confirmation: "a" * 16)
        user.valid?
        expect(user).to be_valid
      end
      it "emailのフォーマットが適切" do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
          first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          user = build(:user, email: valid_address)
          user.valid?
          expect(user).to be_valid
        end
      end
      it "emailが大文字で保存したら小文字に変換されて保存されている" do
        mixed_case_email = "Foo@ExAMPle.CoM"
        user = build(:user, email: mixed_case_email)
        user.valid?
        user.save
        expect(user.reload.email).to eq "foo@example.com"
      end
    end
    context "異常ケース" do
      it "nameが存在しない場合はエラー" do
        user = build(:user, name: "")
        user.valid?
        expect(user.errors[:name]).to include("を入力してください")
      end
      it "nameが空欄場合はエラー" do
        user = build(:user, name: "　　　　　")
        user.valid?
        expect(user.errors[:name]).to include("を入力してください")
      end
      it "emailが存在しない場合はエラー" do
        user = build(:user, email: "")
        user.valid?
        expect(user.errors[:email]).to include("を入力してください")
      end
      it "passwordが存在しない場合はエラー" do
        user = build(:user, password: "")
        user.valid?
        expect(user.errors[:password]).to include("を入力してください")
      end
      it "password_confirmationが存在しない場合はエラー" do
        user = build(:user, password_confirmation: "")
        user.valid?
        expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end
      it "passwordとpassword_confirmationが一致しない場合はエラー" do
        user = build(:user, password_confirmation: "")
        user.valid?
        expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end
      it "大文字小文字を区別せず、すでに入力したemailと同一のemailが登録されていた場合はエラー" do
        user = create(:user)
        another_user = build(:user, email: user.email.upcase)
        another_user.valid?
        expect(another_user.errors[:email]).to include("はすでに存在します")
      end
      it "nameが最大文字数20を超えた場合はエラー" do
        user = build(:user, name: "a" * 21)
        user.valid?
        expect(user.errors[:name]).to include("は20文字以内で入力してください")
      end
      it "emailは最大文字数255を超えた場合はエラー" do
        user = build(:user, email: "a" * 244 + "@example.com")
        user.valid?
        expect(user.errors[:email]).to include("は255文字以内で入力してください")
      end
      it "passwordが最小文字数6を下回っていた場合はエラー" do
        user = build(:user, password: "a" * 5, password_confirmation: "a" * 5)
        user.valid?
        expect(user.errors[:password]).to include("は6文字以上で入力してください")
      end
      it "passwordが最大文字数16を超えた場合はエラー" do
        user = build(:user, password: "a" * 17, password_confirmation: "a" * 17)
        user.valid?
        expect(user.errors[:password]).to include("は16文字以内で入力してください")
      end
      it "emailのフォーマットが不適切な場合はエラー" do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
          foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
          user = build(:user, email: invalid_address)
          user.valid?
          expect(user.errors[:email]).to include("は不正な値です")
        end
      end
    end
  end

  describe 'ユーザーの削除' do
    before do
      @user = create(:user,:activated)
      @otherUser = create(:user,:other)
    end
    it "ユーザーが削除された場合、そのユーザーに紐づくmicropostも削除される" do
      micropost = create(:micropost, user_id: @user.id)
      i = Micropost.count
      expect do
        @user.destroy
      end.to change{ Micropost.count }.from(i).to(i-1)
    end
    it "ユーザーが削除された場合、そのユーザーに紐づくfolloweerも削除される" do
      @user.follow(@otherUser)
      i = Relationship.count
      expect do
        @user.destroy
      end.to change{ Relationship.count }.from(i).to(i-1)
    end
    it "ユーザーが削除された場合、そのユーザーに紐づくfollowedも削除される" do
      @user.follow(@otherUser)
      i = Relationship.count
      expect do
        @otherUser.destroy
      end.to change{ Relationship.count }.from(i).to(i-1)
    end
  end

  describe "ユーザーのフォロー" do
    it "ユーザーをフォロしていない場合からフォローして、解除するまでの一連の流れ" do
      user = create(:user,:activated)
      otherUser = create(:user,:other)
      expect(user).not_to be_following(otherUser)
      user.follow(otherUser)
      expect(user).to be_following(otherUser)
      expect(otherUser.followers).to be_include(user)
      user.unfollow(otherUser)
      expect(user).not_to be_following(otherUser)
    end
  end

  describe "ユーザーのフォローによるfeed" do

  end
end
