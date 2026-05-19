
# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters, if: :devise_controller?

  def new
    build_resource({})
    resource.build_user_profile
    respond_with resource
  end

  def create

    build_resource(sign_up_params)

    ActiveRecord::Base.transaction do

      resource.save!
      family =
        if params[:new_family_name].present?
          Family.create!(name: params[:new_family_name])
        else
          Family.find_by(id: params[:family_id])
        end

      if family.present?
        FamilyMembership.create!(
          user: resource,
          family: family,
          membership_type: params[:membership_type]
        )
      end

    end

    if resource.persisted?

      if resource.active_for_authentication?

        flash[:notice] = "Welcome! Your account has been created successfully."

        sign_up(resource_name, resource)

        respond_with resource,
          location: after_sign_up_path_for(resource)

      else

        expire_data_after_sign_in!

        respond_with resource,
          location: after_inactive_sign_up_path_for(resource)

      end

    else

      clean_up_passwords resource

      set_minimum_password_length

      respond_with resource

    end

  rescue ActiveRecord::RecordInvalid => e

    flash.now[:alert] = e.message

    clean_up_passwords resource

    set_minimum_password_length

    render :new, status: :unprocessable_entity

  end

  protected

  def configure_permitted_parameters

    devise_parameter_sanitizer.permit(:sign_up, keys: [

      :first_name,
      :last_name,
      :identification_type,
      :identification_number,

      :family_id,
      :new_family_name,
      :membership_type,

      user_profile_attributes: [
        :birth_date,
        :marital_status
      ]

    ])

    devise_parameter_sanitizer.permit(:account_update, keys: [

      :first_name,
      :last_name,
      :identification_type,
      :identification_number,

      user_profile_attributes: [
        :birth_date,
        :marital_status
      ]

    ])

  end

end
