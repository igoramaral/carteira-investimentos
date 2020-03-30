ActiveAdmin.register Usuario do
  permit_params :nome, :admin, :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :nome
    column :email
    column :admin
    actions
  end

  filter :nome
  filter :email
  filter :created_at

  form do |f|
    f.inputs do
      f.input :nome
      f.input :admin
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
