require 'helper'

class TestCorpus < Test::Unit::TestCase
  def test_adding_documents_increments_document_count
    corpus = Corpus.new
    doc1 = Document.new("cow cow cow")
    doc2 = Document.new("horse horse horse")

    corpus << doc1
    corpus << doc2

    assert_equal corpus.document_count, 2
  end

  def test_adding_documents_adds_terms
    corpus = Corpus.new
    doc1 = Document.new("cow cow cow bird")
    doc2 = Document.new("horse horse horse bird")

    corpus << doc1
    corpus << doc2

    assert_equal 3, corpus.terms.size

    # cow appears in one document
    assert_equal 1, corpus.terms['cow']

    # horse appears in one document
    assert_equal 1, corpus.terms['horse']

    # bird appears in both documents
    assert_equal 2, corpus.terms['bird']
  end

  def test_inverse_document_frequency
    corpus = Corpus.new
    doc1 = Document.new("cow cow cow")
    doc2 = Document.new("horse horse horse")

    corpus << doc1
    corpus << doc2

    # There's 2 documents and the term appears in 1, so idf = log(2/ (1+1)) = 0
    assert_in_delta corpus.inverse_document_frequency("cow"), 0.0, 0.1

    # There's 2 documents and the term appears in 0, so idf = log(2/1) = 0.69314718056
    assert_in_delta corpus.inverse_document_frequency("bird"), 0.693, 0.001
  end

  def test_similar_documents
    corpus = Corpus.new
    doc1 = Document.new("bird bird bird")
    doc2 = Document.new("pig pig pig bird")
    doc3 = Document.new("horse horse bird bird")

    corpus << doc1
    corpus << doc2
    corpus << doc3

    # it returns nil if the document isn't in the corpus
    assert_nil corpus.similar_documents("this is not a valid document")

    # it returns an array of the documents in order of similarity
    results = corpus.similar_documents(doc1)
    assert_equal [doc1, doc3, doc2], results.map(&:first)
    assert_equal [1.0, 0.579, 0.230], results.map { |r| r.last.round(3) }
  end

  def test_weights
    corpus = Corpus.new
    doc1 = Document.new("cow horse sheep")
    doc2 = Document.new("horse bird dog")

    corpus << doc1
    corpus << doc2

    assert_equal [["horse", -1.0]], corpus.weights(doc1)
  end

  def test_weights_sorts
    corpus = Corpus.new
    doc1 = Document.new("Returns a string containing a representation")
    corpus << Document.new("Adds a string containing a representation")
    corpus << Document.new("Representation of a string")

    corpus << doc1

    doc1_weights = corpus.weights(doc1)
    assert doc1_weights.first[1] > doc1_weights.last[1]
  end

  def test_term_frequency_matrix
    corpus = Corpus.new
    corpus << Document.new("cow horse sheep")
    corpus << Document.new("horse bird dog")

    tdm = corpus.term_document_matrix
    assert tdm.instance_of? TermDocumentMatrix
  end

  def test_remove_infrequent_terms
    corpus = Corpus.new
    corpus << Document.new("cow horse sheep")
    corpus << Document.new("horse bird dog")

    assert_equal 5, corpus.terms.size

    # horse appears in 100% of documents so is kept
    corpus.remove_infrequent_terms!(0.6)

    assert_equal 1, corpus.terms.size
    assert corpus.terms.has_key? "horse"
  end

  def test_remove_frequent_terms
    corpus = Corpus.new
    corpus << Document.new("cow horse sheep")
    corpus << Document.new("horse bird dog")

    assert_equal 5, corpus.terms.size

    # horse appears in 100% of documents so is removed
    corpus.remove_frequent_terms!(0.6)

    assert_equal 4, corpus.terms.size
    assert !corpus.terms.has_key?("horse")
  end
end
