class RemoveBagTemplates < ActiveRecord::Migration[5.2]
  def change
    drop_table :bag_templates
  end
end
