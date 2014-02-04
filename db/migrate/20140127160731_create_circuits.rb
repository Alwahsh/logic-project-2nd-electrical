class CreateCircuits < ActiveRecord::Migration
  def change
    create_table :circuits do |t|
      t.text :input
      t.text :output
      t.boolean :required

      t.timestamps
    end
  end
end
