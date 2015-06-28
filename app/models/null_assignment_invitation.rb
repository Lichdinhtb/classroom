class NullAssignmentInvitation < AssignmentInvitation
  # Public: Set the partial path for the NullAssignmentInvitation
  #
  # Returns the String with the path
  def to_partial_path
    'assignment_invitations/null'
  end

  protected

  def assign_key
    nil
  end
end
