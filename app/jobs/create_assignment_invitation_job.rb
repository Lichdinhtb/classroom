class CreateAssignmentInvitationJob < ActiveJob::Base
  queue_as :default

  # Public: Create an invitation for a given assignment
  #
  # assignment - The Assignment that needs an invitation
  #
  # Returns if the save was successful
  def perform(assignment)
    invitation = assignment.build_assignment_invitation
    invitation.save!
  end
end
