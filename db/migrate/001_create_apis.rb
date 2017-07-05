class CreateApis < ActiveRecord::Migration
  def change
    create_table :apis do |t|

      t.string :name

      t.string :endpoint

      t.text :query

      t.text :description

      t.integer :status, :default => 0

      t.timestamps
    end

  end
end
