class ErrorsController < ApplicationController
  layout false  # без layout

  def not_found
    head :not_found  # просто статус 404, без шаблона
  end

  def forbidden
    head :forbidden
  end

  def internal_error
    head :internal_server_error
  end
end
