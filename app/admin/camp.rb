ActiveAdmin.register Camp do

permit_params :name, :description, :size_of_necessary_space, 
:camp_necessities, :needs_art_grant, :number_of_members, :seeking_members,
:noise_level, :safety_risks, :contact_email, :contact_name, :needs_electricity,
:minbudget, :maxbudget,:minbudget_realcurrency,:maxbudget_realcurrency, :grants_received, :grantingtoggle, :minfunded, :fullyfunded

end
