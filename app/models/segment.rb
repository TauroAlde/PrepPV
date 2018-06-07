class Segment < ApplicationRecord
  belongs_to :parent_segment, foreign_key: :parent_id, class_name: "Segment", optional: true
  has_many :segments, foreign_key: :parent_id, class_name: "Segment", inverse_of: :parent_segment
  # representatives are the entity in charge of the segment in most cases the "casilla"
  # o the leaf segment of the tree
  has_many :representative_users, -> { joins(:user_segments).where('user_segments.representative = ?', true) }, 
                          through: :user_segments, class_name: "User", foreign_key: :user_id
  has_many :non_representative_users, -> { joins(:user_segments).where('user_segments.representative = ? OR user_segments.representative IS NULL', false) }, 
                          through: :user_segments, class_name: "User", foreign_key: :user_id
  has_many :user_segments
  has_many :users, through: :user_segments
  has_many :prep_processes
  has_many :prep_step_ones, through: :prep_processes
  has_many :prep_step_twos, through: :prep_processes
  has_many :prep_step_threes, through: :prep_processes
  has_many :prep_step_fours, through: :prep_processes
  has_many :votes, through: :prep_step_fours
  has_many :segment_processors, through: :prep_processes, foreign_key: :segment_id, class_name: 'User'

  has_many :political_candidacies
  has_many :candidacies, through: :political_candidacies
  has_many :candidates, through: :political_candidacies
  has_many :messages
  has_many :evidences, through: :messages
  belongs_to :district

  validates :name, uniqueness: true

  has_closure_tree
  
  has_many :self_and_descendants, through: :descendant_hierarchies, source: :descendant
  has_many :self_and_ancestors, through: :ancestor_hierarchies, source: :ancestor

  attr_reader :non_representative_users_count, :representative_users_count

  #def self.select_with_count(ids)
  #  select(
  #    <<-SQL
  #        (WITH non_representative_user_segments AS (
  #          SELECT id, segment_id, user_id, representative FROM user_segments
  #          where representative IS NULL oR representative = 'f'
  #        ), representative_user_segments AS (
  #          SELECT id, segment_id, user_id, representative FROM user_segments
  #          where representative IS TRUE
  #        )
  #
  #        SELECT segments.*, COUNT(non_representative_user_segments.id) AS non_representative_users_count, COUNT(representative_user_segments.id) AS representative_users_count
  #        FROM segments
  #        LEFT JOIN non_representative_user_segments ON non_representative_user_segments.segment_id = segments.id 
  #        LEFT JOIN representative_user_segments ON representative_user_segments.segment_id = segments.id
  #        #{conditions_for_select(ids)}
  #        GROUP BY segments.id).*
  #      SQL
  #    )
  #end
  #
  #def self.conditions_for_select(ids)
  #  ids.blank? ?
  #    "" :
  #    "WHERE segments.id #{ ids.is_a?(Array) ? "IN (#{ids.join(', ')})" : "= #{ids}" }"
  #end

  def males_count
    prep_step_twos.empty? ? "S/E" : prep_step_twos.sum(:males)
  end

  def females_count
    prep_step_twos.empty? ? "S/E" : prep_step_twos.sum(:females)
  end

  def openning_time
    prep_step_ones.empty? ? "S/E" : prep_step_ones.last.created_at.strftime("%H:%M %p")
  end

  def closing_time
    prep_processes.completed.empty? ? "S/E" : prep_processes.completed.last.completed_at.strftime("%H:%M %p")
  end

  def voters_count
    prep_step_threes.empty? ? "S/E" : prep_step_threes.sum(:voters_count)
  end

  def percent_difference
    prep_step_threes.empty? ? "S/E" : ((prep_step_threes.sum(:voters_count) - nominal_count) * 100) / nominal_count
  end

  def self.segments_for_messages(user)
    if user.representative?
      (user.represented_segments.map(&:self_and_descendant_ids).flatten + user.non_represented_segments.pluck(:id)).flatten.uniq
    elsif user.only_common?
      user.segments.pluck(:id)
    else
      Segment.joins(:messages).pluck(:id)
    end
  end

  def self.messageable_by(user)
    includes(messages: Message::INCLUDES_BASE, user_segments: [:user]).
      where(id: Segment.segments_for_messages(user))
  end

  def last_message
    messages.order(id: :asc).last
  end

  def last_message_evidences_count
    last_message ? last_message.evidences.count : 0
  end

  def unread_messages_count
    messages.unread.count
  end

  def created_at_day_format
    last_message ? last_message.created_at.strftime("%H:%M %P") : ""
  end

  def self.othon_p_blanco
    find_by(name: "Othon P. Blanco")
  end

  def self.benito_juarez
    find_by(name: "Benito Juarez")
  end

  def self.felipe_carrillo_puerto
    find_by(name: "Felipe Carrillo Puerto")
  end

  def self.jose_maria_morelos
    find_by(name: "Jose Maria Morelos")
  end

  def self.bacalar
    find_by(name: "Bacalar")
  end

  def self.cozumel
    find_by(name: "Cozumel")
  end

  def self.isla_mujeres
    find_by(name: "Isla Mujeres")
  end

  def self.lazaro_cardenas
    find_by(name: "Lazaro Cardenas")
  end

  def self.puerto_morelos
    find_by(name: "Puerto Morelos")
  end

  def self.solidaridad
    find_by(name: "Solidaridad")
  end

  def self.tulum
    find_by(name: "Tulúm")
  end
end
