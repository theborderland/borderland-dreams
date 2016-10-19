class Camp < ActiveRecord::Base
	belongs_to :creator, class_name: 'User', foreign_key: 'user_id'

	has_many :memberships
	has_many :users, through: :memberships
  has_many :images #, :dependent => :destroy

	validates :creator, presence: true
	validates :name, presence: true
	validates :subtitle, presence: true
	validates :contact_email, presence: true
	validates :contact_name, presence: true

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

end
