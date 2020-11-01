require 'rails_helper'

# As a merchant employee
# When I visit my merchant dashboard ("/merchant")
# I see the name and full address of the merchant I work for

feature 'As a merchant' do
  given!(:user) {@merchant_employee = create(:user, role: 1)}
  describe "When I visit my merchant dashboard ('/merchant')" do
    before :each do
      @merchant1 = create(:merchant)
      @merchant1.users << @merchant_employee
      page.set_rack_session(user_id: @merchant_employee.id)
    end
    it "I see the name an full address of the merchant I work for" do
      visit "/merchant"
      expect(page).to have_content(@merchant_employee.merchant.name)
      expect(page).to have_content(@merchant_employee.merchant.address)
      expect(page).to have_content(@merchant_employee.merchant.city)
      expect(page).to have_content(@merchant_employee.merchant.state)
      expect(page).to have_content(@merchant_employee.merchant.zip)
    end
  end
end
