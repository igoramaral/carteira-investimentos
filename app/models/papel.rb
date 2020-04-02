class Papel < ApplicationRecord
    has_many :transacoes
    has_many :ativos
end
