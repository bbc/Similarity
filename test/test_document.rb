require 'helper'

class TestDocument < Test::Unit::TestCase
  def test_initialize
    document = Document.new("The quick brown fox")
    assert_equal document.content, "The quick brown fox"
  end

  def test_term_extraction
    document = Document.new("the quick brown fox")
    assert_equal document.terms, ["the", "quick", "brown", "fox"]
  end

  def test_term_extraction_removes_spaces
    document = Document.new("the quick     brown   fox")
    assert_equal document.terms, ["the", "quick", "brown", "fox"]
  end

  def test_term_extraction_downcases
    document = Document.new("The Quick Brown Fox")
    assert_equal document.terms, ["the", "quick", "brown", "fox"]
  end

  def test_term_extraction_removes_punctuation
    document = Document.new('The, Quick! Brown. "Fox"')
    assert_equal document.terms, ["the", "quick", "brown", "fox"]
  end

  def test_term_frequency
    document = Document.new('cow cow cow horse horse elephant')
    assert document.term_frequency.is_a? Hash

    # should have 3 terms
    assert_equal document.term_frequency.size, 3

    # frequency of cow should be 3/6 = 0.5
    assert_equal document.term_frequency['cow'], 0.5

    # frequency of horse should be 2/6 = 0.333333333333
    assert_in_delta document.term_frequency['horse'], 0.333, 0.001
  end

  def test_has_term
    document = Document.new('cow cow cow horse horse elephant')

    assert_equal true, document.has_term?('cow')
    assert_equal false, document.has_term?('sheep')
  end

  def test_vector_space
    corpus = Corpus.new
    doc1 = Document.new("cow cow cow")
    doc2 = Document.new("cow horse bird sheep")

    corpus << doc1
    corpus << doc2

    vector_space = doc1.vector_space(corpus)
    assert_in_delta -0.405, vector_space[0], 0.001
    assert_equal [0, 0, 0], vector_space[1..3]
  end
end
