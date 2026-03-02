class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :country
      t.string :faculty
      t.string :languages
      t.string :program_type

      t.timestamps
    end
  end
end
