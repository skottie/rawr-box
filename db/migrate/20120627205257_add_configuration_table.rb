class AddConfigurationTable < ActiveRecord::Migration
  def self.up
  	create_table :configuration_values do |t|
			t.string :key
			t.text :value
			t.timestamps
		end
	end

  def self.down
		drop_table :configuration_values
  end
end
