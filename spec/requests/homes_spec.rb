require 'spec_helper'

describe "Home" do

	describe "index" do 
		
		subject { page }
		
		before(:each) { visit root_path }

		it 'should have the right title' do 
			should have_selector('title', text: full_title(''))
		end

		it "should have the right heading" do 
			should have_selector('h1', text: 'Talisman')
		end
	end
end