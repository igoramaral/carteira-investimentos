ActiveAdmin.register Transacao do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :usuario_id, :data, :papel_id, :quantidade, :valor, :tipo
  #
  # or
  #
  # permit_params do
  #   permitted = [:usuario_id, :data, :papel_id, :quantidade, :valor, :tipo]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  menu :label => "Histórico de Transações"

  controller do

    def create
      @transacao = Transacao.new(permitted_params[:transacao])
      @transacao.usuario_id = current_usuario.id
      if @transacao.save
        redirect_to  admin_transacoes_path
      end
    end

  end

  form do |f|
    f.inputs do
      f.input :data
      f.input :papel, member_label: :ticker
      f.input :quantidade
      f.input :valor
      f.input :tipo, :as => :radio, :collection => ["Compra", "Venda"]
    end
    f.actions
  end
end
