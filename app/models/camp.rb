class CanCreateNewDreamValidator < ActiveModel::Validator
  include AppSettings

  def validate(record)
    if app_setting('disable_open_new_dream')
      record.errors[:base] << I18n.t("new_dream_is_disabled")
    end
  end
end

class Camp < ApplicationRecord
  include AppSettings
  extend AppSettings
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :favorites
  has_many :favorite_users, through: :favorites, source: :user
  has_many :approvals
  has_many :approvers, through: :approvals, source: :user
  has_many :images #, :dependent => :destroy
  has_many :safety_sketches
  has_many :grants
  has_many :people, class_name: 'Person'
  has_many :roles, through: :people
  has_many :flag_events
  has_many :budget_items 
  has_many :safety_items 

  has_paper_trail

  accepts_nested_attributes_for :budget_items, allow_destroy: true
  accepts_nested_attributes_for :safety_items, allow_destroy: true

  acts_as_taggable

  validates :creator, presence: true
  validates :name, presence: true
  validates :subtitle, presence: true
  validates :contact_name, presence: true
  validates :minbudget, :numericality => { :greater_than_or_equal_to => 0 }, allow_blank: true
  validates :minbudget_realcurrency, :numericality => { :greater_than_or_equal_to => 0 }, allow_blank: true
  validates :maxbudget, :numericality => { :greater_than_or_equal_to => 0 }, allow_blank: true
  validates :maxbudget_realcurrency, :numericality => { :greater_than_or_equal_to => 0 }, allow_blank: true
  validates_with CanCreateNewDreamValidator, :on => :create

  filterrific(
    default_filter_params: { sorted_by: 'random' },
    available_filters: [
      :sorted_by,
      :search_query,
      :tagged_with,
      :not_fully_funded,
      :not_min_funded,
      :not_seeking_funding,
      :active,
      :not_hidden,
      :is_cocreation
    ]
  )

  # Scope definitions. We implement all Filterrific filters through ActiveRecord
  # scopes. In this example we omit the implementation of the scopes for brevity.
  # Please see 'Scope patterns' for scope implementation details.
    scope :search_query, lambda { |query|
      return nil  if query.blank?
      # condition query, parse into individual keywords
      terms = query.downcase.split(/\s+/)
      # replace "*" with "%" for wildcard searches,
      # append '%', remove duplicate '%'s
      terms = terms.map { |e|
        ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
      }

      or_array = [
        "LOWER(camps.name) LIKE ?",
        "LOWER(camps.subtitle) LIKE ?",
        "LOWER(camps.cocreation) LIKE ?",
      ]

      if app_setting("multi_lang_support")
        or_array.push("LOWER(camps.en_name) LIKE ?",
          "LOWER(camps.en_subtitle) LIKE ?")
      end

      num_or_conditions = or_array.length

      where(
        terms.map {
          or_clauses = or_array.join(' OR ')
          "(#{ or_clauses })"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conditions }.flatten
      )
    }

  scope :sorted_by, lambda { |sort_option|
      # extract the sort direction from the param value.
      direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'

      case sort_option.to_s
      when /^name/
         # Simple sort on the created_at column.
         # Make sure to include the table name to avoid ambiguous column names.
         # Joining on other tables is quite common in Filterrific, and almost
         # every ActiveRecord table has a 'created_at' column.
         order("camps.name #{ direction }")
      when /^updated_at_/
         order("camps.updated_at #{ direction }")
      when /^random$/
         order("random()")
      when /^color$/
         order("camps.color")
      when /^dreamyness$/
         rnd = rand(1..10)
         if rnd == 1
          order("camps.color asc")
         elsif rnd == 2
          order("camps.color desc")
         elsif rnd == 3
          order("camps.updated_at asc")
         elsif rnd == 4
          order("camps.updated_at desc")
         elsif rnd == 5
          order("camps.name asc")
         elsif rnd == 6
          order("camps.name desc")
         else 
          order("random()")
         end
      when /^created_at_/
         order("camps.created_at #{ direction }")
         raise(ArgumentError, "Sort option: #{ sort_option.inspect }")
      else
         raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
      end
  }

  scope :not_fully_funded, lambda { |flag|
    return nil  if 0 == flag # checkbox unchecked
    where(fullyfunded: false)
  }

  scope :not_min_funded, lambda { |flag|
    return nil  if 0 == flag # checkbox unchecked
    where(minfunded: false)
  }

  scope :not_seeking_funding, lambda { |flag|
    return nil  if 0 == flag # checkbox unchecked
    where(grantingtoggle: true)
  }

  scope :active, lambda { |flag|
    where(active: true)
  }

  scope :not_hidden, lambda { |flag|
    where(is_public: flag)
  }

  scope :is_cocreation, lambda { |flag|
    where.not(camps: { cocreation: nil }).where.not(camps: { cocreation: '' })
  }

  before_save :align_budget

  def grants_received
    @grants_received ||= self.grants.sum(:amount)
  end

  def flag_count(flag_type)
    relevant_events = FlagEvent.where(["flag_type = ? and camp_id = ? and value = ?", flag_type, self.id, true])
    relevant_events.count
  end

  def flag_type_is_raised(flag_type)
    relevant_events = FlagEvent.where(["flag_type = ? and camp_id = ?", flag_type, self.id])
    last_event = relevant_events.where(created_at: relevant_events.select('MAX(created_at)')).first
    return last_event.value if last_event != nil

    false
  end
  
  def self.options_for_tags
    ActsAsTaggableOn::Tag.most_used(20).map { |tag| [tag.name + ' ( ' + tag.taggings_count.to_s+ ' )', tag.name]}
  end

  # Translating the real currency to budget
  # This called on create and on update
  # Rounding up 0.1 = 1, 1.2 = 2
  def align_budget
    if self.minbudget_realcurrency.nil?
      self.minbudget = nil
    elsif self.minbudget_realcurrency > 0
      self.minbudget = (self.minbudget_realcurrency / app_setting('grant_value_for_currency')).ceil
    else
      self.minbudget = 0
    end

    if self.maxbudget_realcurrency.nil?
      self.maxbudget = nil
    elsif self.maxbudget_realcurrency > 0
      self.maxbudget = (self.maxbudget_realcurrency / app_setting('grant_value_for_currency')).ceil
    else
      self.maxbudget = 0
    end
  end

  def website_url
    if self.website.index('https://') || self.website.index('http://')
      self.website
    else
      "http://#{self.website}"
    end
  end

  def display_name
    if app_setting('multi_lang_support') && I18n.locale.to_s == 'en'
      en_name || name
    else
      name
    end
  end
  
  def self.count_all_flags
    sql = %{
    SELECT
      camp_id, COUNT(*)
    FROM
      flag_events
    GROUP BY
      camp_id
    }
    # puts(sql)
    results = ActiveRecord::Base.connection.execute(
      sql
    )
    if !results.any?
      return []
    end

    final_hash = Hash.new
    results.each do |result|
      camp_id = result['camp_id']
      count = result['count']
      if !count
        count = 0
      end
      final_hash[camp_id] = count
    end
    # returns list of lists holding [camp_id, flag_count]
    final_hash.sort_by {|_key, value| -value}
  end
end
