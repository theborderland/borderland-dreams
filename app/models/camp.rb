class CanCreateNewDreamValidator < ActiveModel::Validator
  def validate(record)
  	if Rails.application.config.x.firestarter_settings['disable_open_new_dream']
      record.errors[:base] << I18n.t("new_dream_is_disabled")
    end
  end
end

class Camp < ActiveRecord::Base
	belongs_to :creator, class_name: 'User', foreign_key: 'user_id'

	has_many :memberships
	has_many :users, through: :memberships
	has_many :images #, :dependent => :destroy
	has_many :grants

	validates :creator, presence: true
	validates :name, presence: true
	validates :subtitle, presence: true
	validates :contact_email, presence: true
	validates :contact_name, presence: true
	validates :minbudget, :numericality => { :greater_than_or_equal_to => 0 }, allow_blank: true
	validates :minbudget_realcurrency, :numericality => { :greater_than_or_equal_to => 0 }, allow_blank: true
	validates :maxbudget, :numericality => { :greater_than_or_equal_to => 0 }, allow_blank: true
	validates :maxbudget_realcurrency, :numericality => { :greater_than_or_equal_to => 0 }, allow_blank: true
	validates_with CanCreateNewDreamValidator, :on => :create

	filterrific(
	default_filter_params: { sorted_by: 'updated_at_desc' },
	available_filters: [
	  :sorted_by,
	  :search_query,
	  :not_fully_funded,
	  :not_min_funded,
	  :not_seeking_funding
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
	      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
	    }
	    # configure number of OR conditions for provision
	    # of interpolation arguments. Adjust this if you
	    # change the number of OR conditions.
	    num_or_conditions = 2
	    where(
	      terms.map {
	        or_clauses = [
	          "LOWER(camps.name) LIKE ?",
	          "LOWER(camps.subtitle) LIKE ?"
	        ].join(' OR ')
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
	    when /^created_at_/
	       order("camps.created_at #{ direction }")
	       raise(ArgumentError, "Sort option: #{ sort_option.inspect }")
	    else
	       raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
	    end
	}

	scope :not_fully_funded, lambda { |flag|
		return nil  if '0' == flag # checkbox unchecked
		where(fullyfunded: false)
	}

	scope :not_min_funded, lambda { |flag|
		return nil  if '0' == flag # checkbox unchecked
		where(minfunded: false)
	}

	scope :not_seeking_funding, lambda { |flag|
		return nil  if '0' == flag # checkbox unchecked
		where(grantingtoggle: true)
	}

	before_save do
		align_budget
	end

	before_destroy do
		self.memberships.delete_all
		self.save
	end

	def grants_received
		return self.grants.sum(:amount)
	end	

	# Translating the real currency to budget
	# This called on create and on update
	# Rounding up 0.1 = 1, 1.2 = 2
	def align_budget
		if self.minbudget_realcurrency.nil?
			self.minbudget = nil
		elsif self.minbudget_realcurrency > 0
			self.minbudget = (self.minbudget_realcurrency / Rails.application.config.coin_rate).ceil
		else
			self.minbudget = 0
		end

		if self.maxbudget_realcurrency.nil?
			self.maxbudget = nil
		elsif self.maxbudget_realcurrency > 0
			self.maxbudget = (self.maxbudget_realcurrency / Rails.application.config.coin_rate).ceil
		else
			self.maxbudget = 0
		end
	end
end
