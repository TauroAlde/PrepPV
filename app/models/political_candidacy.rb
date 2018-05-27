class PoliticalCandidacy < ApplicationRecord
  has_one :political_party, through: :candidate
  belongs_to :candidate
  belongs_to :segment
  belongs_to :candidacy
  belongs_to :district
  has_many :votes

  accepts_nested_attributes_for :candidate
end
