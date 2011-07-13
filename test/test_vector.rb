require 'helper'

class TestVectorCalculations < Test::Unit::TestCase
  def test_abs
    vector = [2,2]
    assert_in_delta 2.828, VectorCalculations.abs(vector), 0.001
  end

  def test_similarity
    vector1 = [0,1]
    vector2 = [1,1]

    similarity = VectorCalculations.cosine_similarity(vector1, vector2)
    assert_equal (1/Math.sqrt(2)), similarity
  end
end
