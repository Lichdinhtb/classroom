module GitHubRepoable
  extend ActiveSupport::Concern

  included do
    before_validation(on: :create) do
      create_github_repository if organization
    end

    before_create :add_team_to_github_repository
    before_create :push_starter_code

    before_destroy :destroy_github_repository
  end

  # Public
  #
  def add_team_to_github_repository
    github_repository = GitHubRepository.new(organization.github_client, github_repo_id)
    github_team       = GitHubTeam.new(organization.github_client, github_team_id)

    github_team.add_team_repository(github_repository.full_name)
  end

  # Public
  #
  def create_github_repository
    github_repository = github_organization.create_repository(repo_name,
                                                              team_id: github_team_id,
                                                              private: self.private?,
                                                              description: "#{repo_name} created by GitHub Classroom")
    self.github_repo_id = github_repository.id
  end

  # Public
  #
  def destroy_github_repository
    github_organization.delete_repository(github_repo_id)
  end

  # Public
  #
  def push_starter_code
    return true unless starter_code_repo_id

    repository              = GitHubRepository.new(organization.github_client, github_repo_id)
    starter_code_repository = GitHubRepository.new(organization.github_client, starter_code_repo_id)

    repository.get_starter_code_from(starter_code_repository.full_name)
  end

  private

  # Internal
  #
  def github_organization
    @github_organization ||= GitHubOrganization.new(organization.github_client, organization.github_id)
  end
end
