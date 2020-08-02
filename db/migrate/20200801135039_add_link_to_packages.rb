class AddLinkToPackages < ActiveRecord::Migration[6.0]
  def change
    add_column :packages, :link, :string
  end
end
