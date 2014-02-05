module Features
  def login_as(symbol)
    @password = 'fakepassword'
    @user     = create symbol, password: @password, password_confirmation: @password

    login(@user.email, @password)
  end

  def login(email,password)
    visit login_path
    fill_in :user_email,    with: email
    fill_in :user_password, with: password
    click_button 'Login'
  end
end