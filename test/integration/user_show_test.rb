require "test_helper"

class UserShowTest < ActionDispatch::IntegrationTest
  def setup
    @inactive_user = users(:inactive)
    @active_user = users(:leonard)
  end
  test "should redirect when user is not activated" do
    get user_path(@inactive_user)
    assert true
    assert_response :redirect
    assert_redirected_to root_url
  end
  test "should  not redirect when user is activated" do
    get user_path(@active_user)
    assert_response :success
    assert_template 'users/show'
  end
end
