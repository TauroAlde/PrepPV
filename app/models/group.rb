class Group < ApplicationRecord
  has_many :permissions
  has_many :users, through: :user_groups
  has_many :user_groups, inverse_of: :group

  validates_uniqueness_of :name
end
