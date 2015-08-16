class GroupAssignmentRepo < ActiveRecord::Base
  include GitHubRepoable

  has_one :organization, through: :group_assignment

  has_many :repo_accesses, through: :group

  belongs_to :group
  belongs_to :group_assignment

  validates :github_repo_id, presence:   true
  validates :github_repo_id, uniqueness: true

  validates :group_assignment, presence: true

  validates :group, presence: true
  validates :group, uniqueness: { scope: :group_assignment }

  # Public: Determine if the GroupAssignmentRepo's GroupAssignment is private
  #
  # Example
  #
  #  group_assignment_repo.private?
  #  # => true
  #
  # Returns a boolean
  def private?
    !group_assignment.public_repo?
  end

  private

  # Internal: Return the GitHub team id from GroupAssignmentRepos Group
  # Returns the GitHub Team id as an Integer
  def github_team_id
    group.github_team_id
  end

  # Internal: Build the title for the GroupAssignmentRepo
  # Returns the title as a String
  def repo_name
    "#{group_assignment.title}-#{group.title}"
  end

  # Internal: Return the starter_code_repo_id from GroupAssignmentRepos
  # GroupAssignment
  #
  # Returns the starter_code_repo_id as an Integer
  def starter_code_repo_id
    group_assignment.starter_code_repo_id
  end
end
