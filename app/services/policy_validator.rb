class PolicyValidator
  def initialize(policy)
    @policy = policy
  end

  def validate(user)
    return true if user.super_admin?

    # if to the current group no policy is applied
    # TODO: validate policy of the ancestors!!
    return true unless @policy

    @policy.allowed_to.each { |rule|
      return true if %r{#{rule}}.match(user.email)
    }
    false
  end
end
