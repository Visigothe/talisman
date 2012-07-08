require 'spec_helper'

describe "Layouts" do
  
  subject { page }

  describe "navbar" do 
    before { visit root_path }
    it { should have_selector(".brand", text: 'Talisman') }
    it { should have_link('Talisman', href: root_path) }
    it { should have_link('Sign Up', href: new_user_registration_path) }
  end
end