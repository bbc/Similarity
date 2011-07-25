require 'gsl'

class Corpus
  attr_reader :terms

  def initialize
    @terms = {}
    @documents = []
    @term_document_matrix = nil
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
    term_document_matrix.transpose * term_document_matrix
  end

  def term_document_matrix
    if @term_document_matrix
      return @term_document_matrix
    else
      @term_document_matrix = GSL::Matrix.alloc(@terms.size, document_count)

      @documents.each_with_index do |document, document_index|
        @terms.each_with_index do |term, term_index|
          term = term.first
          idf = inverse_document_frequency(term)
          weight = document.term_frequency(term) * idf
          @term_document_matrix[term_index, document_index] = weight
        end
      end

      @term_document_matrix.each_col { |col| col.div!(col.norm) }
    end
  end

  def weights(document)
    idx = @documents.index(document)
    terms = @terms.to_a.map {|term| term.first}
    weights = term_document_matrix.col(idx).to_a

    # create array of array pairs of terms and weights
    term_weight_pairs = terms.zip(weights)

    # remove zero weights
    term_weight_pairs.reject! {|pair| pair[1].zero?}

    # sort in descending order
    term_weight_pairs.sort {|x,y| y[1] <=> x[1]}
  end
end
