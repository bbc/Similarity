require 'helper'

class TestTermDocumentMatrix < Test::Unit::TestCase
  # using worked example from log book, this should return a similarity of 1
  def test_similarity_matrix
    corpus = Corpus.new
    doc1 = Document.new(:content => "cow horse sheep")
    doc2 = Document.new(:content => "horse bird dog")

    corpus << doc1
    corpus << doc2

    tdm = corpus.term_document_matrix
    similarity_matrix = tdm.similarity_matrix

    assert_in_delta 1, similarity_matrix[0,0], 0.1
    assert_in_delta 1, similarity_matrix[0,1], 0.1
  end

  def test_filter_sparsity
    corpus = Corpus.new
    corpus << Document.new(:content => "sheep dog")
    corpus << Document.new(:content => "horse dog")

    tdm = corpus.term_document_matrix
    assert_equal tdm.to_a.size, 3
    assert_equal tdm.labels, ["sheep", "dog", "horse"]

    tdm.remove_sparse_terms(0.6)
    assert_equal tdm.to_a.size, 1
    assert_in_delta tdm.matrix[0,0], -1, 0.01
    assert_in_delta tdm.matrix[0,1], -1, 0.01
    assert_equal ["dog"], tdm.labels
  end
end
