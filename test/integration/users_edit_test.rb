require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:leonard)
    @other_user = users(:richard)
  end
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              email: "foo@invalid",
                                              password: "foo",
                                              password_confirmation: "bar" } }
    assert_select "div.alert", text: "The form contains 4 errors"
    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "different name"
    email = "different@mail.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password:  "" ,
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "different name"
    email = "different@mail.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    assert_nil session[:forwarding_url]
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "should redirect edit when not loggen in" do
    get edit_user_path(@user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    name = "different name"
    email = "different@mail.com"
    originalName = @user.name
    originalEmail = @user.email
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password:  "" ,
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to login_url
    @user.reload
    assert_equal originalName, @user.name
    assert_equal originalEmail, @user.email
  end

  test "should redirect edit when logged in as the wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as the wrong user" do
    log_in_as(@other_user)
    name = "different name"
    email = "different@mail.com"
    originalName = @user.name
    originalEmail = @user.email
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password:  "" ,
                                              password_confirmation: "" } }

    assert_redirected_to root_url
    assert flash.empty?
    @user.reload
    assert_equal originalName, @user.name
    assert_equal originalEmail, @user.email
  end
end
