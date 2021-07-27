# frozen_string_literal: true

class CreateLabelPrinters < ActiveRecord::Migration[6.1]
  def change
    create_table :label_printers do |t|
      t.string :name, null: false
      t.integer :type_of, null: false
      t.integer :language_type, null: false
      t.string :host
      t.integer :port
      t.string :fluics_api_key
      t.string :fluics_lid

      t.timestamps
    end
  end
end
