# frozen_string_literal: true

class GraphqlController < ApiController
  include ActiveStorage::SetCurrent

  before_action :authenticate_request!
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    domain = request.headers['X-Store-Domain']
    current_store = Store.find_by(domain: domain)

    # Raise error if store not found
    raise ActiveRecord::RecordNotFound, "Store not found for domain: #{domain}" unless current_store

    context = {
      current_store: current_store
    }

    result = ApiSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  def current_store
    context[:current_store]
  end

  private

  def authenticate_request!
    token = request.headers['Authorization']

    # Compare the incoming token with the token stored in the environment variable
    if token.nil? || token != ENV['API_ACCESS_TOKEN']
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end
