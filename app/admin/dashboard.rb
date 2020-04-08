require 'net/http'

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  page_action :calcular_valores, method: :get do
    id = params[:id]
    @ativo = Ativo.find(id)

    if !@ativo.nil?
      ticker = @ativo.papel.ticker
      qtd = @ativo.quantidade
      valor_medio = @ativo.valor_medio

      url = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{ticker}.SA&interval=5min&apikey=RTBABEF7PHX68A7Y"
      uri = URI(url)
      res = Net::HTTP.get_response(uri)
      body = JSON.parse(res.body)
      valor_atual = body["Global Quote"]["05. price"].to_f
      posicao = (qtd * valor_atual) - (qtd * valor_medio)
      
      resposta = {:preco => valor_atual, :posicao => posicao}

      render json: resposta
    end
  end

  content title: proc { I18n.t("active_admin.dashboard") } do
    if current_usuario.admin?
      columns do
        column do
          panel "Gerenciar Usuários" do
            ul do
              li link_to("Adicionar novo usuário", new_admin_usuario_path)
              li link_to("Listar Usuários", admin_usuarios_path)
            end
          end
        end

        column do
          panel "Gerenciar Papéis" do
            ul do
              li link_to("Adicionar novo Papel", new_admin_papel_path)
              li link_to("Listar Papéis", admin_papeis_path)
            end
          end
        end
      end

    else
      columns do
        column do
          panel "Meus ativos" do
            render partial: 'tabela_ativos'
          end
        end
        column do
          panel "Gerenciar Transições" do
            ul do
              li link_to("Adicionar nova Transação", new_admin_transacao_path)
              li link_to("Listar Transações", admin_transacoes_path)
            end
          end
        end
      end
    end
    
  end # content
end
