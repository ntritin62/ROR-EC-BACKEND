module ParamSnakeCase
  extend ActiveSupport::Concern

  included do
    before_action :convert_params_to_snake_case, if: :request_has_body?
  end

  private

  def request_has_body?
    request.parameters.present?
  end

  def convert_params_to_snake_case
    params.deep_transform_keys! { |key| key.underscore.to_sym }
  end
end
