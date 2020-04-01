ActiveAdmin.register Usuario do
  # permit_params :nome, :admin, :email, :password, :password_confirmation 
  permit_params do
    permitted = [:nome, :email, :password, :password_confirmation]
    permitted << :other if current_usuario.admin?
    permitted
  end

  index do
    selectable_column
    id_column
    column :nome
    column :email
    if current_usuario.admin?
      column :admin
    end
    actions
  end

  filter :nome
  filter :email
  filter :created_at

  form do |f|
    f.inputs do
      f.input :nome
      if current_usuario.admin?
        f.input :admin
      end
      f.input :email
      f.input :password, :required => true if params[:action] == 'create'
      f.input :password_confirmation, :required => true if params[:action] == 'create'
    end
    f.actions
  end

end
