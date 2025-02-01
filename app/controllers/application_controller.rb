class ApplicationController < ActionController::Base
  def set_csrf_token_header
    response.set_header('X-CSRF-Token', form_authenticity_token)
  end
end
