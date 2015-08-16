class Assignment < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  default_scope { where(deleted_at: nil) }

  has_one :assignment_invitation, dependent: :destroy

  has_many :assignment_repos, dependent: :destroy

  belongs_to :creator, class_name: User
  belongs_to :organization

  validates :creator, presence: true

  validates :organization, presence: true

  validates :title, presence: true
  validates :title, uniqueness: { scope: :organization }

  validate :uniqueness_of_title_across_organization

  # Public: Get the AssignmentInvitation
  #
  # Returns the AssignmentInvitation or a NullAssignmentInvitation if
  # the invitation does not exist
  def assignment_invitation
    super || NullAssignmentInvitation.new
  end

  # Public: Determine if the Assignment is private
  #
  # Example
  #
  #  assignment.public?
  #  # => true
  #
  # Returns a boolean
  def private?
    !public_repo
  end

  # Public: Determine if the Assignment is public
  #
  # Example
  #
  #  assignment.private?
  #  # => true
  #
  # Returns a boolean
  def public?
    public_repo
  end

  # Public: Determine if the Assignment has starter code
  #
  # Example
  #
  #  assignment.starter_code?
  #  # => true
  #
  # Returns if the starter_code_repo_id column is not NULL
  def starter_code?
    starter_code_repo_id.present?
  end

  private

  # Internal: Verify that there aren't any GroupAssignments in the
  # Assignments Organization that have the same title.
  #
  # This will add an error to the title column if there is a match
  def uniqueness_of_title_across_organization
    return unless GroupAssignment.where(title: title, organization: organization).present?
    errors.add(:title, 'has already been taken')
  end
end
