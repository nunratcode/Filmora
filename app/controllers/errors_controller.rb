class ErrorsController < ApplicationController
  layout "application"

  def not_found
    render status: 404
  end

  def forbidden
    render status: 403
  end

  def internal_error
    render status: 500
  end
end
