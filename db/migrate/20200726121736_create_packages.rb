class CreatePackages < ActiveRecord::Migration[6.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :description
      t.string :depends
      t.string :rev_depends

      t.timestamps
    end
  end
end
