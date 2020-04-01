class CreatePapers < ActiveRecord::Migration[5.2]
  def change
    create_table :papers do |t|
      t.string :nome
      t.string :ticker
      t.string :tipo

      t.timestamps
    end
    add_index :papers, :tipo, unique: true
  end
end
