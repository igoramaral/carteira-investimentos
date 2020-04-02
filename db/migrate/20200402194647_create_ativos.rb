class CreateAtivos < ActiveRecord::Migration[5.2]
  def change
    create_table :ativos do |t|
      t.references :usuario, foreign_key: true
      t.references :papel, foreign_key: true
      t.integer :quantidade
      t.decimal :valor_medio, precision: 8, scale: 2

      t.timestamps
    end
  end
end
