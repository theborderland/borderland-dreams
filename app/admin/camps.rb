ActiveAdmin.register Camp do
  permit_params :subtitle, :contact_email, :contact_name, :contact_phone, :description, :electricity, :light, :fire, :noise, :nature, :moop, :plan, :cocreation, :neighbors, :budgetplan, :minbudget, :maxbudget, :seeking_members, :index_camps_on_user_id, :grantingtoggle, :created_at, :updated_at, :minfunded, :fullyfunded, :recycling, :minbudget_realcurrency, :maxbudget_realcurrency, :safetybag_crewsize, :safetybag_plan, :safetybag_builder, :safetybag_safetyer, :safetybag_mooper, :safetybag_materials, :safetybag_work_in_height, :safetybag_tools, :safetybag_grounding, :safetybag_safety, :safetybag_electricity, :safetybag_daily_routine, :safetybag_other_comments, :safetybag_firstMemberName, :safetybag_firstMemberEmail, :safetybag_secondMemberName, :safetybag_secondMemberEmail, :dreamprop_philosophy, :dreamprop_inspiration, :dreamprop_interactivity_audience_participation, :dreamprop_interactivity_is_fire_present, :dreamprop_interactivity_fire_present_desc, :dreamprop_interactivity_is_sound, :dreamprop_interactivity_sound_desc, :dreamprop_interactivity_is_fire_event, :dreamprop_interactivity_fire_event_desc, :dreamprop_community_is_installation_present_for_event, :dreamprop_community_is_installation_present_for_public, :dreamprop_community_is_context, :dreamprop_community_context_desc, :dreamprop_community_is_interested_in_publicity, :dreamprop_theme_is_annual, :dreamprop_theme_annual_desc, :active, :about_the_artist, :website, :is_public, :spec_physical_description, :spec_length, :spec_width, :spec_height, :spec_visual_night_day, :spec_is_electricity, :spec_electricity_details, :spec_electricity_how, :spec_electricity_is_daytime, :spec_electricity_watt, :safety_is_heavy_equipment, :safety_equipment, :safety_how_to_build_safety, :safety_how, :safety_grounding, :safety_securing, :safety_securing_parts, :safety_signs, :location_info, :program_dream_name_he, :program_dream_name_en, :program_dreamer_name_he, :program_dreamer_name_en, :program_dream_about_he, :program_dream_about_en, :program_special_activity, :google_drive_folder_path, :google_drive_budget_file_path, :dreamscholarship_fund_is_from_art_fund, :dreamscholarship_fund_is_open_for_public, :dreamscholarship_budget_min_original, :dreamscholarship_budget_max_original, :dreamscholarship_budget_max_original_desc, :dreamscholarship_bank_account_info, :dreamscholarship_financial_conduct_is_intial_budget, :dreamscholarship_financial_conduct_intial_budget_desc, :dreamscholarship_financial_conduct_money_raise_desc, :dreamscholarship_execution_potential_previous_experience, :dreamscholarship_execution_potential_work_plan, :projectmgmt_is_theme_camp_dream, :projectmgmt_is_dream_near_theme_camp, :projectmgmt_dream_pre_construction_site, :en_name, :en_subtitle, :borderland2017, :dream_point_of_contact_email

  member_action :show do
      @camp = Camp.includes(versions: :item).find(params[:id])
      @versions = @camp.versions 
      @camp = @camp.versions[params[:version].to_i].reify if params[:version]
      show!
  end

  member_action :history do
    @camp = Camp.find(params[:id])
    @versions = PaperTrail::Version.where(item_type: 'Camp', item_id: @camp.id)
    render "layouts/history"
  end

  sidebar :versionate, :partial => "layouts/version", :only => :show
end
