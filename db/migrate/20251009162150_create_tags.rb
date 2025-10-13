class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false, index: { unique: true }
      t.boolean :fixed, default: false

      t.timestamps
    end
  end
end
