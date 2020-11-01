require 'rails_helper'

# As a merchant employee
# When I visit my merchant dashboard ("/merchant")
# I see the name and full address of the merchant I work for

feature 'As a merchant' do
  given!(:user) {@merchant_employee = create(:user, role: 1)}
  before :each do
    page.set_rack_session(user_id: @merchant_employee.id)
    @merchant1 = create(:merchant)
  end
  describe "When I visit my merchant dashboard ('/merchant')" do
    it "I see the name an full address of the merchant I work for" do
      visit "/merchant"
      
    end
  end
end
