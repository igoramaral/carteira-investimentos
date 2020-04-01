ActiveAdmin.register Papel do

   # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :nome, :ticker, :tipo
  #
  # or
  #
  # permit_params do
  #   permitted = [:nome, :ticker]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  menu :label => "Papéis"

  form do |f|
    f.inputs do
      f.input :nome
      f.input :ticker
      f.input :tipo, :as => :radio, :collection => ["Ação", "FII"]
    end
    f.actions
  end
  
end
