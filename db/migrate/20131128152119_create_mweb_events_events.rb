class CreateMwebEventsEvents < ActiveRecord::Migration
  def change
    create_table :mweb_events_events do |t|
      t.string :name
      t.datetime :start_on
      t.datetime :end_on
      t.string :location
      t.string :address
      t.text :description
      t.references :owner, :polymorphic => true

      t.timestamps
    end
  end
end
