class AddIdsToResponsibles < ActiveRecord::Migration
  def change
    add_reference :responsibles, :person, index: true, foreign_key: true
    add_reference :responsibles, :camp, index: true, foreign_key: true
  end
end
