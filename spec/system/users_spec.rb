require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe "new regstration" do
    it "sign up" do
      user = build(:user)
      visit  new_user_registration_path
      fill_in "user_name", with: "#{user.name}"
      fill_in "user_email", with: "#{user.email}"
      fill_in "user_password", with: "#{user.password}"
      fill_in "user_password_confirmation", with: "#{user.password}"
      click_button "Sign up"
      expect(page).to have_content "アカウント登録が完了しました"
    end
  end

  describe "show profile" do
    before do
      @post = create(:post)
      login(@post.user)
      click_on "#{@post.user.name}"
    end

    it "have user profile" do
      expect(page).to have_content "Profile"
    end

    it "have user image" do
      expect(page).to have_selector("img[src$='assets/default.jpg']")
    end

    describe "change account information" do
      before do
        click_on "プロフィール変更"
      end

      it "change user name" do
        fill_in "user_name", with: "change_name"
        fill_in "user_current_password", with: "#{@post.user.password}"
        click_on "更新する"
        expect(page).to have_content "change_name"
      end

      it "change user email" do
        fill_in "user_email", with: "test@test.com"
        fill_in "user_current_password", with: "#{@post.user.password}"
        click_on "更新する"
        expect(page).to have_content "test@test.com"
      end

      it "change user profile" do
        fill_in "user_profile", with: "I watch a lot of anime"
        fill_in "user_current_password", with: "#{@post.user.password}"
        click_on "更新する"
        expect(page).to have_content "I watch a lot of anime"
      end

      it "change user image" do
        attach_file("user[image]", "#{Rails.root}/spec/fixtures/files/user_image.png", make_visible: true)
        fill_in "user_current_password", with: "#{@post.user.password}"
        click_on "更新する"
        expect(page).to have_selector("img[src$='user_image.png']")
      end

      it "change user password" do
        fill_in "user_password", with: "abcdefg"
        fill_in "user_password_confirmation", with: "abcdefg"
        fill_in "user_current_password", with: "#{@post.user.password}"
        click_on "更新する"
        @post.user.reload
        expect(@post.user.valid_password?("testuser")).to eq(false)
        expect(@post.user.valid_password?("abcdefg")).to eq(true)
      end

      it "don't change profile without current_password" do
        fill_in "user_name", with: "change_name"
        fill_in "user_email", with: "test@test.com"
        fill_in "user_profile", with: "I watch a lot of anime"
        attach_file("user[image]", "#{Rails.root}/spec/fixtures/files/user_image.png", make_visible: true)
        fill_in "user_password", with: "abcdefg"
        fill_in "user_password_confirmation", with: "abcdefg"
        click_on "更新する"
        expect(page).to have_content "保存できませんでした"
      end
    end
  end

  describe "guest user can't change user profile" do
    it "is not button プロフィール変更" do
      visit edit_user_registration_path
      click_on "ゲストログイン"
      expect(page).not_to have_content "プロフィール変更"
    end
  end
end
