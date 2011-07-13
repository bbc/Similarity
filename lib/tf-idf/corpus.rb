class Corpus
  attr_reader :terms, :document_count

  def initialize
    @terms = {}
    @document_count = 0
  end

  def <<(document)
    @document_count += 1
    document.terms.uniq.each do |term|
      if @terms[term]
        @terms[term][:count] += 1
      else
        @terms[term] = {:count => 1}
      end
    end
  end

  def inverse_document_frequency(term)
    puts "#{@document_count} / (1 + #{document_count_for_term(term)})" if $DEBUG
    Math.log(@document_count.to_f / (1 + document_count_for_term(term)))
  end

  def document_count_for_term(term)
    if @terms[term]
      @terms[term][:count]
    else
      0
    end
  end

  def similarity(document1, document2)
    # find the terms contained in both documents
    common_terms = document1.term_frequency.keys | document2.term_frequency.keys

    # vector space for documents
    document1_vector_space = []
    document2_vector_space = []
    common_terms.each do |term|
      idf = inverse_document_frequency(term)
      if tf = document1.term_frequency[term]
        puts "#{tf} * #{idf}" if $DEBUG
        document1_vector_space << (tf * idf)
      else
        document1_vector_space << 0
      end

      if document2.term_frequency[term]
        document2_vector_space << (document2.term_frequency[term] * idf)
      else
        document2_vector_space << 0
      end
    end

    # calculate cosine_similarity between the two vector spaces
    Array.cosine_similarity(document1_vector_space, document2_vector_space)
  end
end
