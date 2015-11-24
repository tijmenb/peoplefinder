class PolicyValidator
  def initialize(group)
    @group = group
    @policies_validated = 0
  end

  def validate(user)
    return true if user.super_admin?

    validate_rules_for(@group, user) || @policies_validated.zero?
  end

  private
    def validate_rules_for(group, user)
      if group.policy.present?
        @policies_validated += 1
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
