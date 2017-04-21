# Registration methods for API
class Api::V1::RegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_filter :check_token

  def create
    resource = User.new(user_params)
    if resource.valid?
      resource.save
      render json: resource, status: 200
    else
      render json: resource.errors.messages, status: 422
    end
  end

  def update
    resource = User.find_by(id: params[:id])
    resource.update(user_params)
    # resource.avatar = params[:avatar]
    if resource.valid?
      resource.save
      render json: resource.as_json(methods: [:avatar_url]), status: 200
    else
      render json: resource.errors.messages, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :email,
                                 :password,
                                 :phone,
                                 :date_of_birthday,
                                 :invitation_sent,
                                 :avatar,
                                 :role_name,
                                 :role_description,
                                 :role_image_url)
  end
end
