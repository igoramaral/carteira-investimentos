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

    def scoped_collection
      super.includes :usuario, :papel
    end

  end

  scope "Todas",:all
  scope :compra
  scope :venda
  filter :papel, member_label: :ticker
  filter :data
  

  
  index do
    selectable_column
    id_column
    if current_usuario.admin?
      column :usuario, sortable: 'usuarios.nome' do |transacao|
        transacao.usuario.nome
      end
    end
    
    column :data
    column :papel, sortable: 'papeis.ticker' do |transacao|
      transacao.papel.ticker
    end
    column :tipo_de_papel, sortable: 'papeis.tipo' do |transacao|
      transacao.papel.tipo
    end
    column :quantidade
    column :valor
    column :tipo_de_transação, sortable: :tipo do |transacao|
      transacao.tipo
    end
    actions
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
