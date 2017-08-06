require 'test_helper'

class ChampionControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get champion_home_url
    assert_response :success
  end

  test "should get about" do
    get champion_about_url
    assert_response :success
  end

  test "should get draft" do
    get champion_draft_url
    assert_response :success
  end

end
