class User < ActiveRecord::Base
  enum state: [:active, :pending]

  has_many :repo_accesses, dependent: :destroy

  has_and_belongs_to_many :organizations

  validates :token, presence: true, if: :active?
  validates :token, uniqueness: true, allow_blank: true, if: :pending?

  validates :uid, presence: true
  validates :uid, uniqueness: true

  # Public: Create a new User from an OAuth hash
  #
  # hash - The Omniauth OAuth hash to create the User from
  #
  # Returns whether or not the User was created
  def self.create_from_auth_hash(hash)
    create!(AuthHash.new(hash).user_info)
  end

  # Public: Update a Users attributes from an OAuth hash
  #
  # hash - The Omniauth OAuth hash to create the User from
  #
  # Returns
  def assign_from_auth_hash(hash)
    user_attributes = AuthHash.new(hash).user_info.merge(state: 'active')
    update_attributes(user_attributes)
  end

  # Public: Find the User from the given OAuth hash
  #
  # hash - The Omniauth OAuth hash to find the User
  #
  # Returns: The found User Activerecord object
  def self.find_by_auth_hash(hash)
    conditions = AuthHash.new(hash).user_info.slice(:uid)
    find_by(conditions)
  end

  # Public: Get users GitHubClient or set a new one with
  # their personal access token
  #
  # Returns The Users GitHubClient
  def github_client
    @github_client ||= Octokit::Client.new(access_token: token, auto_paginate: true)
  end

  # Public: Determin if the User is a site_admin
  # Returns site_admin
  def staff?
    site_admin
  end
end
