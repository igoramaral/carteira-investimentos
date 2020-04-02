class Transacao < ApplicationRecord
  belongs_to :usuario
  belongs_to :papel

  scope :compra, -> { where(tipo: 'Compra') }
  scope :venda, -> { where(tipo: 'Venda') }
end
