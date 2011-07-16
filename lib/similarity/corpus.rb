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

  def similarity(document1, document2, include_weights = false)
    # find the terms contained in both documents
    common_terms = document1.term_frequencies.keys | document2.term_frequencies.keys

    # vector space for documents
    document1_vector_space = []; document2_vector_space = []

    # hash to store the weights
    document1_weights = {}; document2_weights = {}

    common_terms.each do |term|
      idf = inverse_document_frequency(term)

      document1_weight = document1.term_frequency(term) * idf
      document1_vector_space << document1_weight

      document2_weight = document2.term_frequency(term) * idf
      document2_vector_space << document2_weight

      if include_weights
        document1_weights[term] = document1_weight
        document2_weights[term] = document2_weight
      end
    end

    # calculate cosine_similarity between the two vector spaces
    similarity = VectorCalculations.
      cosine_similarity(document1_vector_space, document2_vector_space)

    # return similarity and weights
    if include_weights
      return [similarity, document1_weights, document2_weights]
    else
      return similarity
    end
  end
end
