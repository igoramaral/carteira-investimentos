class CreateTransacoes < ActiveRecord::Migration[5.2]
  def change
    create_table :transacoes do |t|
      t.references :usuario, foreign_key: true
      t.timestamp :data
      t.references :papel, foreign_key: true
      t.integer :quantidade
      t.decimal :valor, precision: 8, scale: 2
      t.string :tipo

      t.timestamps
    end
  end
end
