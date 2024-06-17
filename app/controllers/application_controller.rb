class ApplicationController < ActionController::API
  def not_found 
    render json: {error: 'not_found from app' }
  end
  
  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    if BlackListedToken.exists?(token: header)
      render json: {errors: 'Token is Invalid'}, status: :unauthorized
      return
    end
      
    begin
      # debugger
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
