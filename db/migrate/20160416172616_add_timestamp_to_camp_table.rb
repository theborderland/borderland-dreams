class AddTimestampToCampTable < ActiveRecord::Migration
	def change
	    change_table(:camps) { |t| t.timestamps }
	end
end