require 'helper'

class TestTermDocumentMatrix < Test::Unit::TestCase
  # using worked example from log book, this should return a similarity of 1
  def test_similarity_matrix
    corpus = Corpus.new
    doc1 = Document.new("cow horse sheep")
    doc2 = Document.new("horse bird dog")

    corpus << doc1
    corpus << doc2

    tdm = corpus.term_document_matrix
    similarity_matrix = tdm.similarity_matrix

    assert_in_delta 1, similarity_matrix[0,0], 0.1
    assert_in_delta 1, similarity_matrix[0,1], 0.1
  end

  def test_number_of_terms
    corpus = Corpus.new
    corpus << Document.new("cow horse sheep")
    corpus << Document.new("horse bird dog")

    tdm = TermDocumentMatrix.new(corpus)

    assert_equal 5, tdm.number_of_terms
  end

  def test_number_of_documents
    corpus = Corpus.new
    corpus << Document.new("cow horse sheep")
    corpus << Document.new("horse bird dog")

    tdm = TermDocumentMatrix.new(corpus)

    assert_equal 2, tdm.number_of_documents
  end

  def test_non_zeros
    corpus = Corpus.new
    corpus << Document.new("cow horse sheep")
    corpus << Document.new("horse bird dog")

    tdm = TermDocumentMatrix.new(corpus)
    assert_equal 2, tdm.non_zeros
  end
end
