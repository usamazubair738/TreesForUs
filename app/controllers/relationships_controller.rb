class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def new
    @user = current_user
  end

  def create
    parent = User.find(params[:parent_id])
    child  = User.find(params[:child_id])

    relationship = UserParentRelationship.new(parent: parent, child: child)

    if relationship.save
      redirect_to dashboard_index_path, notice: "#{child.first_name} added as child of #{parent.first_name}"
    else
      redirect_to dashboard_index_path, alert: relationship.errors.full_messages.join(", ")
    end
  end

  def destroy
    relationship = UserParentRelationship.find(params[:id])
    relationship.destroy
    redirect_to dashboard_index_path, notice: "Relationship removed"
  end
end