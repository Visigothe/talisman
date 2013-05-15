include ApplicationHelper

module Utilities

  def confirm_and_signin(user)
    user.confirm!
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

  def signin(user)
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

  def signup(user)
    visit new_user_registration_path
  	fill_in 'Email',                  with: user.email
  	fill_in 'Password',               with: user.password
  	fill_in 'Password confirmation',  with: user.password
  	click_button 'Sign up'
  end

  def signup_someone
    visit new_user_registration_path
    fill_in 'Email', with: 'someone@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'
  end
end
