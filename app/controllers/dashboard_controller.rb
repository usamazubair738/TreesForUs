# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user         = current_user
    @user_profile = @user.user_profile

    preload_family_relationships

    @root_member  = find_root_member(current_user)
    @family_tree  = build_family_tree(@root_member)
  end

  private

 def preload_family_relationships
  User.includes(
    :parents,
    :children,
    :user_profile,
    user_partners:         :partner,
    inverse_user_partners: :user,
    user_profile: { avatar_attachment: :blob }
  )
end
  def find_root_member(user)
    current = user
    visited = Set.new
    while current.parents.any?
      break if visited.include?(current.id)
      visited.add(current.id)
      current = current.parents.first
    end
    current
  end

 def build_family_tree(user, visited = Set.new)
  return nil if visited.include?(user.id)
  visited.add(user.id)

  all_partners = partner_ids_for(user)

  {
    user:     user,
    profile:  user.user_profile,
    partners: all_partners,
    children: children_of(user, all_partners).map do |child|
                build_family_tree(child, visited)
              end.compact
  }
end

def partner_ids_for(user)
  rows = ActiveRecord::Base.connection.execute(<<~SQL)
    SELECT CASE
      WHEN user_id    = #{user.id} THEN partner_id
      WHEN partner_id = #{user.id} THEN user_id
    END AS other_id
    FROM user_partners
    WHERE user_id = #{user.id} OR partner_id = #{user.id}
  SQL

  ids = rows.map { |r| r["other_id"] }.compact.uniq
  ids.any? ? User.includes(:user_profile).where(id: ids) : []
end

def children_of(user, partners)
  parent_ids = [user.id] + partners.map(&:id)
  User.joins(:parent_relationships)
      .where(user_parent_child_relationships: { parent_id: parent_ids })
      .distinct
end
end