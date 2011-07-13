require 'helper'

class TestVectorSpace < Test::Unit::TestCase
  def test_abs
    vector = [2,2]
    assert_in_delta 2.828, vector.abs, 0.001
  end

  def test_similarity
    vector1 = [0,1]
    vector2 = [1,1]

    similarity = vector1.similarity(vector2)
    assert_equal (1/Math.sqrt(2)), similarity
  end
end
