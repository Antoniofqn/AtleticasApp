class ApplicationController < ActionController::Base

  ##
  # Fallback to app index
  #
  def fallback_index_html
    render file: 'public/index.html'
  end

  ##
  # After devise sign in, redirect to rails admin dashboard
  #
  def after_sign_in_path_for(resource)
    admin_root_path
  end

  ##
  # After devise sign sign out, redirect to rails admin sign in page
  #
  def after_sign_out_path_for(resource)
    admin_root_path
  end
end
