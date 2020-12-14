require 'rails_helper'

RSpec.describe "UsersControllers", type: :request do

  describe "GET #index" do
    context "すでにサインインしている場合" do
      before do
        @user = create(:user,:activated)
        for i in 1..100
          create(:user,:activated,email:"factory#{i}@railstutorial.org")
        end
        log_in_as(@user)
      end
      it "responseがOK(200)である" do
        get "/users"
        expect(response).to have_http_status(200)
      end
      it "レスポンスのボディに照会するuserのnameが含まれている" do
        get "/users"
        for user in User.paginate(page:1)
          expect(response.body).to include (user.name)
        end
      end
      it "レスポンスのボディにuserのnameが含まれている" do
        get "/users"
        for user in User.paginate(page:1)
          expect(response.body).to include (user.name)
        end
        for user in User.paginate(page:2)
          expect(response.body).not_to include (user.name)
        end
        get "/users" ,params:{page:2}
      end
      it "レスポンスのボディにuserのnameがpageのパラメータを受けて変化している" do
        get "/users" ,params:{page:"2"}
        for user in User.paginate(page:"2")
          expect(response.body).to include (user.name)
        end
      end
    end
    context "まだサインインしていない場合" do
      it "responseがリダイレクト(302)である" do
        get "/users"
        expect(response).to have_http_status(302)
      end
      it "responseがログイン画面にリダイレクトしている" do
        get "/users"
        expect(response).to redirect_to "/login"
      end
    end
  end

  describe "DELETE #destroy" do
    context "adminユーザーの場合" do
      before do
        @user = create(:user,:activated,:admin)
        @otherUser = create(:user,:other)
        log_in_as(@user)
      end
      it "responseがリダイレクト(302)である" do
        delete "/users/#{@otherUser.id}"
        expect(response).to have_http_status(302)
      end
      it "responseが/users画面にリダイレクトしている" do
        delete "/users/#{@otherUser.id}"
        expect(response).to redirect_to "/users"
      end
      it "指定したユーザーが削除される" do
        i = User.count
        expect do
          delete "/users/#{@otherUser.id}"
        end.to change{ User.count }.from(i).to(i-1)
      end
    end
    context "adminユーザーではない場合" do
      before do
        @user = create(:user,:activated)
        @otherUser = create(:user,:other)
        log_in_as(@user)
      end
      it "responseがリダイレクト(302)である" do
        delete "/users/#{@otherUser.id}"
        expect(response).to have_http_status(302)
      end
      it "responseがルート画面にリダイレクトしている" do
        delete "/users/#{@otherUser.id}"
        expect(response).to redirect_to "/"
      end
      it "指定したユーザーが削除されない" do
        beforeUserCount = User.count
        delete "/users/#{@otherUser.id}"
        afterUserCount = User.count
        expect(beforeUserCount).to eq afterUserCount
      end
    end
    context "ログインしていない場合" do
      before do
        @user = create(:user,:activated)
        @otherUser = create(:user,:other)
      end
      it "responseがリダイレクト(302)である" do
        delete "/users/#{@otherUser.id}"
        expect(response).to have_http_status(302)
      end
      it "responseがログイン画面にリダイレクトしている" do
        delete "/users/#{@otherUser.id}"
        expect(response).to redirect_to "/login"
      end
      it "指定したユーザーが削除されない" do
        beforeUserCount = User.count
        delete "/users/#{@otherUser.id}"
        afterUserCount = User.count
        expect(beforeUserCount).to eq afterUserCount
      end
    end
  end

  describe "GET #new" do
    context "すでにサインインしている場合" do
      before do
        @user = create(:user,:activated)
        log_in_as(@user)
      end
      it "responseがOK(200)である" do
        get "/users/new"
        expect(response).to have_http_status(200)
      end
    end
    context "まだサインインしていない場合" do
      it "responseがリダイレクト(200)である" do
        get "/users/new"
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST #create" do
    context "すでにサインインしている場合" do
      before do
        @user = create(:user,:activated)
        log_in_as(@user)
      end
      it "responseがOK(302)である" do
        post "/users",params: {user:{name:"create" , email: 'create@railstutorial.org', password: 'password', password_confirmation: 'password'} }
        expect(ActionMailer::Base.deliveries.size).to eq(1)
        expect(ActionMailer::Base.deliveries.first.body.parts[1].body.raw_source).to match("create")
      end
    end
    context "まだサインインしていない場合" do
      it "responseがリダイレクト(302)である" do
        post "/users",params: {user:{name:"create" , email: 'create@railstutorial.org', password: 'password', password_confirmation: 'password'} }
        expect(response).to have_http_status(302)
      end
      it "responseがログイン画面にリダイレクトしている" do
        post "/users",params: {user:{name:"create" , email: 'create@railstutorial.org', password: 'password', password_confirmation: 'password'} }
        expect(response).to redirect_to "/login"
      end
    end
  end

  describe "GET #show" do
    context "すでにサインインしている場合" do
      before do
        @user = create(:user,:activated)
        @otherUser = create(:user,:other)
        log_in_as(@user)
      end
      it "responseがOK(200)である" do
        get "/users/#{@user.id}"
        expect(response).to have_http_status(200)
      end
      it "レスポンスのボディに照会するuserのnameが含まれている" do
        get "/users/#{@user.id}"
        expect(response.body).to include (@user.name)
        #otherUserの名前はuserとは変えている
        expect(response.body).not_to include (@otherUser.name)
      end
    end
    context "まだサインインしていない場合" do
      before do
        @user = create(:user,:activated)
      end
      it "responseがOK(200)である" do
        get "/users/#{@user.id}"
        expect(response).to have_http_status(200)
      end
      it "レスポンスのボディに照会するuserのnameが含まれている" do
        get "/users/#{@user.id}"
        expect(response.body).to include (@user.name)
      end
    end
  end

  describe "GET #edit" do
    context "すでにサインインしている場合" do
      before do
        @user = create(:user,:activated)
        log_in_as(@user)
      end
      it "responseがOK(200)である" do
        get "/users/#{@user.id}/edit"
        expect(response).to have_http_status(200)
      end
    end
    context "まだサインインしていない場合" do
      before do
        @user = create(:user,:activated)
      end
      it "responseがリダイレクト(302)である" do
        get "/users/#{@user.id}/edit"
        expect(response).to have_http_status(302)
      end
      it "responseがログイン画面にリダイレクトしている" do
        get "/users"
        expect(response).to redirect_to "/login"
      end
    end
  end

  describe "PUT #update" do
    context "すでにサインインしている場合" do
      before do
        @user = create(:user,:activated)
        log_in_as(@user)
      end
      it "responseがOK(200)である" do
        get "/users"
        expect(response).to have_http_status(200)
      end
    end
    context "まだサインインしていない場合" do
      it "responseがリダイレクト(302)である" do
        get "/users"
        expect(response).to have_http_status(302)
      end
      it "responseがログイン画面にリダイレクトしている" do
        get "/users"
        expect(response).to redirect_to "/login"
      end
    end
  end
end
