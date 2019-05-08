ActiveAdmin.register Camp do

  scope :active, default: true do |dreams|
    dreams.active(true)
  end
  scope :displayed_with_tags, default: false
  scope("Public") { |scope| scope.where(is_public: true) }
  scope("Private") { |scope| scope.where(is_public: false) }
  scope("Inactive") { |scope| scope.where(active: false) }

  remove_filter *%i(tag_taggings taggings base_tags)
  index do
    selectable_column

    (Camp.column_names - EXCLUDED).each do |cn|
      column I18n.t("activerecord.attributes.camp.#{cn}"), cn
    end

    column(:tags) { |camp|
      camp.tags.collect(&:name).join(', ')
    }
  end

  csv do
    (Camp.column_names - EXCLUDED).each do |cn|
      column cn
    end
    Camp.tag_counts.map(&:name).sort_by(&:downcase).each do |t|
      column(t) { |camp|
        camp.tags.collect(&:name).include?(t)
      }
    end
  end



  permit_params do |params|
    Camp.columns.map(&:name) - %w(id updated_at created_at)
  end
end
