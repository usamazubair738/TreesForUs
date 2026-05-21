class FamiliesController < ApplicationController
  before_action :set_family, only: %i[ show edit update destroy ]


  def index
    @families = Family.all
  end


  def show
  end


 def new
  existing_types = current_user.family_memberships.pluck(:membership_type)
  if existing_types.include?("birth") && existing_types.include?("marriage")
    redirect_to families_path, alert: "You already belong to two families (birth and marriage)."
    return
  end
  @family = Family.new
end


  def edit
  end



def create
  @family = Family.new(family_params)

  respond_to do |format|

    begin

      ActiveRecord::Base.transaction do

        @family.save!

        existing_types = current_user.family_memberships.pluck(:membership_type)

        if existing_types.include?("birth") && existing_types.include?("marriage")

          @family.errors.add(
            :base,
            "You already belong to two families."
          )

          raise ActiveRecord::Rollback
        end

        membership_type =
          existing_types.include?("birth") ? :marriage : :birth

        current_user.family_memberships.create!(
          family: @family,
          membership_type: membership_type
        )

      end

      if @family.errors.any?
        format.html do
          render :new, status: :unprocessable_entity
        end

        format.json do
          render json: @family.errors,
                 status: :unprocessable_entity
        end

      else

        format.html do
          redirect_to @family,
          notice: "Family was successfully created."
        end

        format.json do
          render :show,
                 status: :created,
                 location: @family
        end

      end

    rescue ActiveRecord::RecordInvalid => e

      @family.errors.add(:base, e.record.errors.full_messages.to_sentence)

      format.html do
        render :new, status: :unprocessable_entity
      end

      format.json do
        render json: @family.errors,
               status: :unprocessable_entity
      end

    end

  end
end


  def update
    respond_to do |format|
      if @family.update(family_params)
        format.html { redirect_to @family, notice: "Family was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @family }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @family.destroy!

    respond_to do |format|
      format.html { redirect_to families_path, notice: "Family was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_family
      @family = Family.find(params.expect(:id))
    end

    def family_params
      params.expect(family: [ :name ])
    end
end
