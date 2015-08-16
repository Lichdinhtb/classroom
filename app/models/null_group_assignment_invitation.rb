class NullGroupAssignmentInvitation < GroupAssignmentInvitation
  # Public: Set the partial path for the NullGroupAssignmentInvitation
  #
  # Returns the String with the path
  def to_partial_path
    'assignment_invitations/null'
  end

  protected

  # Internal: Set the key to be nil
  # Returns nil
  def assign_key
    nil
  end
end
