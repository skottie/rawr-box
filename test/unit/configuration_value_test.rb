require 'test_helper'

class ConfigurationValueTest < ActiveSupport::TestCase

  test "participants returns a list of participants" do
    ConfigurationValue.create_or_update('participants', 'foo, bar, baz')
    assert_equal 3, ConfigurationValue.participants.length
    assert_equal 'foo', ConfigurationValue.participants.first
  end

end