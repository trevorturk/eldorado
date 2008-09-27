require 'test_helper'

class ViewingTest < ActiveSupport::TestCase
  
  def test_that_user_id_and_topic_id_are_required
    v = Viewing.new(:user_id => 1, :topic_id => 2)
    assert v.valid?
    v = Viewing.new(:user_id => 1)
    assert !v.valid?
    v = Viewing.new(:topic_id => 1)
    assert !v.valid?
  end
  
  def test_that_user_and_topic_combo_must_be_unique
   Viewing.create!(:user_id => 1, :topic_id => 2)
   assert_raises ActiveRecord::RecordInvalid do
     Viewing.create!(:user_id => 1, :topic_id => 2)
   end
  end

end
