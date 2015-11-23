class PolicyValidator
  def initialize(group)
    @group = group
  end

  def validate(user)
    return true if user.super_admin?

    validate_rules_for(@group, user)
  end

  private
    def validate_rules_for(group, user)
      if group.policy.present?
        group.policy.allowed_to.each { |rule|
          return true if %r{#{rule}}.match(user.email)
        }
      end

      # call for the parent if has one
      if group.parent.present?
        validate_rules_for(group.parent, user)
      else
        false
      end
    end
end
