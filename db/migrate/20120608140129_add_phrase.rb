class AddPhrase < ActiveRecord::Migration
  def self.up
  	create_table :phrases do |t|
			t.string :phrase
			t.string :voice
			t.string :label
			t.timestamps
		end
	end

  def self.down
		drop_table :phrases
  end
end
