require 'helper'

class TestDocument < Test::Unit::TestCase
  def test_initialize
    document = Document.new("The quick brown fox")
    assert_equal document.content, "The quick brown fox"
  end

  def test_initialize_with_id
    document = Document.new("The quick brown fox", "new")
    assert_equal document.content, "The quick brown fox"
    assert_equal document.id, "new"
  end

  def test_initialize_with_no_id
    document = Document.new("The quick brown fox")
    assert_equal document.content, "The quick brown fox"
    assert_equal document.id, document.object_id
  end

  def test_initialize_with_nil
    assert_raise(ArgumentError) { Document.new(nil) }
  end

  def test_initialize_with_blank
    assert_raise(ArgumentError) { Document.new("") }
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

  def test_term_frequencies
    document = Document.new('cow cow cow horse horse elephant')
    assert document.term_frequencies.is_a? Hash

    # should have 3 terms
    assert_equal document.term_frequencies.size, 3

    # frequency of cow should be 3/6 = 0.5
    assert_equal document.term_frequencies['cow'], 0.5

    # frequency of horse should be 2/6 = 0.333333333333
    assert_in_delta document.term_frequencies['horse'], 0.333, 0.001
  end

  def test_term_frequency
    document = Document.new('cow cow cow horse horse elephant')

    # frequency of cow should be 3/6 = 0.5
    assert_equal document.term_frequency('cow'), 0.5

    # frequency of sheep should be 0
    assert_equal document.term_frequency('sheep'), 0
  end

  def test_has_term
    document = Document.new('cow cow cow horse horse elephant')

    assert_equal true, document.has_term?('cow')
    assert_equal false, document.has_term?('sheep')
  end
end
