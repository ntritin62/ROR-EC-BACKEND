module Response
  extend ActiveSupport::Concern

  def render_json(status:, message:, data: nil, errors: nil, http_status: :ok)
    render json: {
      status: status,
      message: message,
      data: data,
      errors: errors
    }.compact, status: http_status
  end
end
