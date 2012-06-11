class AddFileName < ActiveRecord::Migration
  def self.up
  	add_column :sounds, :filename, :string
	end

  def self.down
  end
end
