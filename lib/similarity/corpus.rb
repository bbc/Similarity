require 'gsl'

class Corpus
  attr_reader :terms

  def initialize
    @terms = {}
    @documents = []
  end

  def document_count
    @documents.size
  end

  def <<(document)
    document.terms.uniq.each do |term|
      if @terms[term]
        @terms[term] += 1
      else
        @terms[term] = 1
      end
    end
    @documents << document
  end

  def inverse_document_frequency(term)
    puts "#{document_count} / (1 + #{document_count_for_term(term)})" if $DEBUG
    Math.log(document_count.to_f / (1 + document_count_for_term(term)))
  end

  def document_count_for_term(term)
    if @terms[term]
      @terms[term]
    else
      0
    end
  end

  def similarity_matrix
    matrix = GSL::Matrix.alloc(@terms.size, document_count)

    @documents.each_with_index do |document, document_index|
      @terms.each_with_index do |term, term_index|
        term = term[0]
        idf = inverse_document_frequency(term)
        weight = document.term_frequency(term) * idf
        matrix[term_index, document_index] = weight
      end
    end

    matrix.each_col { |col| col.div!(col.norm) }
    matrix.transpose * matrix
  end
end
