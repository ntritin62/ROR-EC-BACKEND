module ParamSnakeCase
  extend ActiveSupport::Concern

  included do
    before_action :convert_params_to_snake_case
  end

  private

  def convert_params_to_snake_case
    params.transform_keys! { |key| key.underscore.to_sym }
  end
end
