class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :name
      t.text :data

      t.timestamps
    end
  end
end
