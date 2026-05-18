class FamilyMembershipsController < ApplicationController
  before_action :set_family_membership, only: %i[ show edit update destroy ]

  # GET /family_memberships or /family_memberships.json
  def index
    @family_memberships = FamilyMembership.all
  end

  # GET /family_memberships/1 or /family_memberships/1.json
  def show
  end

  # GET /family_memberships/new
  def new
    @family_membership = FamilyMembership.new
  end

  # GET /family_memberships/1/edit
  def edit
  end

  # POST /family_memberships or /family_memberships.json
  def create
    @family_membership = FamilyMembership.new(family_membership_params)

    respond_to do |format|
      if @family_membership.save
        format.html { redirect_to @family_membership, notice: "Family membership was successfully created." }
        format.json { render :show, status: :created, location: @family_membership }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @family_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /family_memberships/1 or /family_memberships/1.json
  def update
    respond_to do |format|
      if @family_membership.update(family_membership_params)
        format.html { redirect_to @family_membership, notice: "Family membership was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @family_membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @family_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /family_memberships/1 or /family_memberships/1.json
  def destroy
    @family_membership.destroy!

    respond_to do |format|
      format.html { redirect_to family_memberships_path, notice: "Family membership was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family_membership
      @family_membership = FamilyMembership.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def family_membership_params
      params.expect(family_membership: [ :user_id, :family_id, :membership_type ])
    end
end
