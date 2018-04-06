class Segment < ApplicationRecord
  belongs_to :parent_segment, foreign_key: :parent_id, class_name: "Segment", optional: true
  has_many :segments, foreign_key: :parent_id, class_name: "Segment", inverse_of: :parent_segment
  # representatives are the entity in charge of the segment in most cases the "casilla"
  # o the leaf segment of the tree
  has_many :representative_users, ->(o) { where('user_segments.representative = ?', true) }, 
                          through: :user_segments, class_name: "User", foreign_key: :user_id
  has_many :user_segments
  has_many :users, through: :user_segments
  has_many :prep_processes
  has_many :segment_processors, through: :prep_processes, foreign_key: :segment_id, class_name: 'User'

  validates :name, uniqueness: true

  has_closure_tree
end
