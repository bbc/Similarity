require 'gsl'

class TermDocumentMatrix
  attr_reader :matrix, :labels

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
    @labels = corpus.terms.to_a.map {|e| e[0]}
  end

  def remove_sparse_terms(sparsity_threshold)
    rows_to_keep = []
    index = 0
    @matrix.each_row do |row|
      length = row.size.to_f
      number_of_zeros = 0
      row.each {|e| number_of_zeros += 1 if e.zero?}
      sparsity =  number_of_zeros / length
      if sparsity < sparsity_threshold
        rows_to_keep << index
      end
      index +=1
    end

    new_matrix = GSL::Matrix.alloc(rows_to_keep.size, @matrix.size[1])
    new_labels = []

    rows_to_keep.each_with_index do |old_index, new_index|
      new_matrix.set_row(new_index, @matrix.row(old_index))
      new_labels[new_index] = @labels[old_index]
    end

    @matrix = new_matrix
    @labels = new_labels
  end

  def similarity_matrix
    self.matrix.transpose * self.matrix
  end

  def col(idx)
    @matrix.col(idx)
  end

  def to_a
    @matrix.to_a
  end
end
