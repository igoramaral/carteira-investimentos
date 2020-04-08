ActiveAdmin.register Transacao do

  permit_params :usuario_id, :data, :papel_id, :quantidade, :valor, :tipo

  menu :label => "Histórico de Transações"

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

  controller do

    def create
      #cria transação e seta o id como o id do usuário atual
      @transacao = Transacao.new(permitted_params[:transacao])
      @transacao.usuario_id = current_usuario.id
      
      if @transacao.save
        atualiza_ativo(@transacao)
        redirect_to admin_dashboard_path
      end
      
    end

    def destroy
      @transacao = Transacao.find(params[:id])
      @ativo = Ativo.find_by(usuario_id: @transacao.usuario.id, papel_id: @transacao.papel.id)
      @transacao.delete
      calcula_valor_medio(@ativo)
      if @ativo.quantidade <= 0
        @ativo.delete
      else
          @ativo.save
      end
      redirect_to admin_transacoes_path
    end

    def atualiza_ativo(transacao)
      @ativo = Ativo.find_or_initialize_by(usuario_id: transacao.usuario.id, papel_id:transacao.papel.id)
  
      if transacao.tipo == 'Compra'
          if @ativo.new_record?
            @ativo.quantidade =  transacao.quantidade 
            @ativo.valor_medio = transacao.valor
          else
            calcula_valor_medio(@ativo)
          end
      else
        if @ativo.new_record?
          flash[:error] = "Você não pode inserir uma transação de venda se não possuir o ativo para vender."
          transacao.delete
          return redirect_to admin_transacoes_path
        else
          if @ativo.quantidade < transacao.quantidade
            flash[:error] = "Você não pode inserir uma transação de venda se a quantidade for maior do que a quantidade que você possui do ativo"
            transacao.delete
            return redirect_to admin_transacoes_path
          else
            @ativo.quantidade -= transacao.quantidade
          end
        end
      end
  
      if @ativo.quantidade <= 0
          @ativo.delete
      else
          @ativo.save
      end
    end
  
    def calcula_valor_medio(ativo)
        qtd = 0
        valor = 0
        transacoes = Transacao.all.where(usuario_id: current_usuario.id, papel_id: ativo.papel.id)
        transacoes.each do |t|
          if t.tipo == 'Compra'
              valor = ((valor * qtd) + (t.quantidade * t.valor))/(t.quantidade + qtd)
              qtd += t.quantidade
          else
              qtd -= t.quantidade
          end
        end
        ativo.valor_medio = valor
        ativo.quantidade = qtd
    end

    def scoped_collection
      super.includes :usuario, :papel
    end

  end
end
