module RequestSpecHelper
  def auth_headers(user)
    user.create_new_auth_token
  end
end
