class ProblemReportMailerPreview < ActionMailer::Preview

  def problem_report
    details_hash = {
      goal: 'Some goal',
      problem: 'A very big problem',
      person_email: 'imnothappy@example.com',
      timestamp: Time.now.to_i,
    }

    ProblemReportMailer.problem_report(details_hash)
  end
end
