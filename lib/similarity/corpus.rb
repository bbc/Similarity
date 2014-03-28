require 'gsl'

class Corpus
  attr_reader :terms, :documents

  def initialize
    @terms = Hash.new(0)
    @documents = []
    @term_document_matrix = nil
    @similarity_matrix = nil
  end

  def document_count
    @documents.size
  end

  def <<(document)
    document.terms.uniq.each { |term| @terms[term] += 1 }

    @documents << document
  end

  def remove_infrequent_terms!(percentage)
    number_of_docs = document_count.to_f
    @terms = terms.delete_if {|term, count| (count.to_f / number_of_docs) < percentage}
    @term_document_matrix = nil
    @similarity_matrix = nil
  end

  def remove_frequent_terms!(percentage)
    number_of_docs = document_count.to_f
    @terms = terms.delete_if {|term, count| (count.to_f / number_of_docs) > percentage}
    @term_document_matrix = nil
    @similarity_matrix = nil
  end

  def inverse_document_frequency(term)
    puts "#{document_count} / (1 + #{document_count_for_term(term)})" if $DEBUG
    Math.log(document_count.to_f / (1 + document_count_for_term(term)))
  end

  def document_count_for_term(term)
    @terms[term]
  end

  def similarity_matrix
    if @similarity_matrix
      return @similarity_matrix
    else
      @similarity_matrix = term_document_matrix.similarity_matrix
    end
  end

  def term_document_matrix
    if @term_document_matrix
      return @term_document_matrix
    else
      @term_document_matrix = TermDocumentMatrix.new(self)
    end
  end

  def similar_documents(document)
    index = documents.index(document)
    return nil if index.nil?

    results = documents.each_with_index.map do |doc, doc_index|
      similarity = similarity_matrix[index, doc_index]
      [doc, similarity]
    end
    results.sort { |a,b| b.last <=> a.last }
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
