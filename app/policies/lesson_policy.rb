class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    @record.course.user_id == @user.id || @user.has_role?(:admin) || @record.course.bought(@user) == false
  end

  def edit?
    @record.course.user_id == @user.id
  end

  def update?
    @record.course.user_id == @user.id
  end

  def new?
    # @user.has_role?(:teacher)
  end

  def create?
   # @user.has_role?(:teacher)
   @record.course.user_id == @user.id
  end

  def destroy?
    @record.course.user_id == @user.id
  end

end
