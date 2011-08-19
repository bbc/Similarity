require 'gsl'

class TermDocumentMatrix
  attr_reader :matrix

  def initialize(corpus)
    @matrix = GSL::Matrix.alloc(corpus.terms.size, corpus.document_count)

    corpus.documents.each_with_index do |document, document_index|
      corpus.terms.each_with_index do |term, term_index|
        term = term.first
        idf = corpus.inverse_document_frequency(term)
        weight = document.term_frequency(term) * idf
        @matrix[term_index, document_index] = weight
      end
    end

    @matrix.each_col { |col| col.div!(col.norm) }
  end

  def similarity_matrix
    self.matrix.transpose * self.matrix
  end

  def col(idx)
    @matrix.col(idx)
  end
end
