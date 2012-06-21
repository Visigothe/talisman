require 'spec_helper'

describe "Layouts" do
  
	subject { page }

  describe "navbar" do 

  before(:each) { visit root_path }
  	
	  it "should have a brand" do 
	  	should have_selector(".brand", text: 'Talisman')
	  end

	  it "should have a link to the home page" do 
	  	should have_link('Talisman', href: root_path)
	  end
  end
end
