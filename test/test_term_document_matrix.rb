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
end
