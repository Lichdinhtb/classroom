class Organization < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  default_scope { where(deleted_at: nil) }

  has_many :assignments,       dependent: :destroy
  has_many :groupings,         dependent: :destroy
  has_many :group_assignments, dependent: :destroy
  has_many :repo_accesses,     dependent: :destroy

  has_and_belongs_to_many :users

  validates :github_id, presence: true, uniqueness: true
  validates :title,     presence: true, uniqueness: { case_sensitive: false }

  after_save :validate_minimum_number_of_users

  # Public: Retrieve both Assignments and Group Assignments
  # for the organization.
  #
  # Returns an array of assignments or NullAssignment
  # if the organization doesn't have any yet
  def all_assignments
    assignments + group_assignments
  end

  # Public: Return an active users GitHub Client for API user
  #
  # Example
  #
  #   organization.github_client
  #   # => #<Octokit::Client:0x3fe32a050c4c>
  #
  # Returns an authenticated Octokit::Client
  def github_client
    users.where(state: 'active').sample.github_client
  end

  private

  # Internal
  #
  def validate_minimum_number_of_users
    return if users.count > 0
    error_message = 'must have at least one user'
    errors.add(:users, error_message)
    fail ActiveRecord::RecordInvalid.new(self), error_message
  end
end
