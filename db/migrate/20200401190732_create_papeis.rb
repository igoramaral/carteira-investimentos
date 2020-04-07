class CreatePapeis < ActiveRecord::Migration[5.2]
  def change
    create_table :papeis do |t|
      t.string :nome
      t.string :ticker
      t.string :tipo

      t.timestamps
    end
    add_index :papeis, :ticker, unique: true
  end
end
