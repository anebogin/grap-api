class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :data
      t.string :data_type
      t.belongs_to :target, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
