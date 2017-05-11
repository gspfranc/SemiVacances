require 'test_helper'

class VacanceDayControllerTest < ActionDispatch::IntegrationTest
  test "should get approbation" do
    get vacance_day_approbation_url
    assert_response :success
  end

end
