class AddSound < ActiveRecord::Migration
  def self.up
  	create_table :sounds do |t|
			t.string :path
			t.string :label
			t.timestamps
		end
	end

  def self.down
  end
end
