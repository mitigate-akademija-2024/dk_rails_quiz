class QuizInvitationMailer < ApplicationMailer
  def invite(email, quiz, sender)
    @quiz = quiz
    @sender = sender
    @url = new_user_registration_url(redirect_to: do_quiz_quiz_url(@quiz))

    mail(to: email, subject: "You've been invited to take a quiz!")
  end
end
