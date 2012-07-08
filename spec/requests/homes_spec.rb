require 'spec_helper'

describe "Home" do

	describe "index" do 
		
		subject { page }
		
		before { visit root_path }

		heading_and_title('Talisman', '')
	end
end