require 'test_helper'

class ConfigurationValueTest < ActiveSupport::TestCase

  test "participants returns a list of participants" do
    ConfigurationValue.create_or_update('participants', 'foo, bar, baz')
    assert_equal 3, ConfigurationValue.participants.length
    assert_equal 'foo', ConfigurationValue.participants.first
  end

  test "ConfigurationValue.value will create a key if it doesn't exist" do
    ConfigurationValue.destroy_all
    assert_equal 0, ConfigurationValue.count
    assert_nil ConfigurationValue.value('foobar')
    assert_equal 1, ConfigurationValue.count
  end

  test "ConfigurationValue.value will return the value of a key when it exists" do
    ConfigurationValue.create_or_update('foobar', 'foobaz')
    assert_equal 'foobaz', ConfigurationValue.value('foobar')
  end

end