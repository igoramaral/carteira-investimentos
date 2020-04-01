class Transacao < ApplicationRecord
  belongs_to :usuario
  belongs_to :papel
end
