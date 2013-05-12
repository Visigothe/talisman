require 'spec_helper'

describe "Home" do

	describe "index" do 
		
		subject { page }
		
		before { visit root_path }

    it { should have_title('Talisman') }
    it { should have_selector('h1') }
	end
end