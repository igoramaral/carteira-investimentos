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
      #cria transação e seta o id como o id do usuário atual
      @transacao = Transacao.new(permitted_params[:transacao])
      @transacao.usuario_id = current_usuario.id

      
      @ativo = Ativo.find_by("usuario_id = ? AND  papel_id = ?", @transacao.usuario_id, @transacao.papel.id)
      if @transacao.tipo == 'Compra'
        if @ativo.nil?
          @papel = Papel.find(@transacao.papel_id)
          @ativo = Ativo.new(usuario: current_usuario, papel: @papel, quantidade: @transacao.quantidade, valor_medio: @transacao.quantidade)
        else
          qtd = 0
          valor = 0
          transacoes = Transacao.all.where(usuario_id: current_usuario.id, papel_id: @transacao.papel.id)
          transacoes.each do |t|
            if t.tipo == 'Compra'
              valor = ((valor * qtd) + (t.quantidade * t.valor))/(t.quantidade + qtd)
              qtd += t.quantidade
            else
              qtd -= t.quantidade
            end
          end

          @ativo.valor_medio = ((valor * qtd) + (@transacao.quantidade * @transacao.valor))/(qtd + @transacao.quantidade)
          @ativo.quantidade += @transacao.quantidade
        end
      else
        if @ativo.nil?
          flash[:error] = "Você não pode inserir uma transação de venda se não possuir o ativo para vender."
          return redirect_to admin_transacoes_path
        else
          if @ativo.quantidade < @transacao.quantidade
            flash[:error] = "Você não pode inserir uma transação de venda se a quantidade for maior do que a quantidade que você possui do ativo"
            return redirect_to admin_transacoes_path
          else
            @ativo.quantidade -= @transacao.quantidade
          end
        end
      end
      
      if @transacao.save
        if @ativo.quantidade == 0
          @ativo.delete
        else
          @ativo.save
        end
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
      f.input :data, as: :datetime_picker, :size => 16
      f.input :papel, member_label: :ticker
      f.input :quantidade
      f.input :valor
      f.input :tipo, :as => :radio, :collection => ["Compra", "Venda"]
    end
    f.actions
  end
end
