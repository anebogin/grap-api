class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.string :target_url

      t.timestamps null: false
    end
  end
end
