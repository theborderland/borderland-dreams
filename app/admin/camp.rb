ActiveAdmin.register Camp do

permit_params :name, :description, :size_of_necessary_space, 
:camp_necessities, :needs_art_grant, :number_of_members, :seeking_members,
:noise_level, :safety_risks, :contact_email, :contact_name,
 :contact_alternative_name, :needs_electricity,
:minbudget, :maxbudget,:minbudget_realcurrency,:maxbudget_realcurrency,
 :grants_received, :grantingtoggle, :minfunded, :fullyfunded,
:safetybag_crewsize, :safetybag_plan, :safetybag_builder,
:safetybag_safetyer, :safetybag_mooper, :safetybag_materials,
:safetybag_work_in_height, :safetybag_tools, :safetybag_grounding,
:safetybag_safety, :safetybag_electricity, :safetybag_daily_routine,
:safetybag_other_comments


end
