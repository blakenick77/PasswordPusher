require 'test_helper'

class PasswordCreationTest < ActionDispatch::IntegrationTest
  def test_password_creation
    get "/"
    assert_response :success

    post "/p", params: { :password => { payload: "testpw" } }
    assert_response :redirect

    follow_redirect!
    assert_response :success
    assert_select "p", "Your password is..."
    # Validate the first view share note
    div = css_select "div.share_note"
    assert(div.length == 1)
    assert(div.first.content.include?('Use this secret link'))

    # Reload the password page, we should not have the first view share note
    get request.url
    assert_response :success
    assert_select "p", "Your password is..."
    div = css_select "div.share_note"
    assert(div.length == 0)
  end
end
