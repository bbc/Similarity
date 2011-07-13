class Document
  attr_reader :content, :term_frequency

  def initialize(text)
    @content = text
    @term_frequency = nil
    @terms = nil
  end

  def terms
    @terms ||=
      @content.gsub(/(\d|\s|\W)+/, ' ').
      split(/\s/).map { |term| term.downcase }
  end

  def term_frequency
    @term_frequency ||= calculate_term_frequency
  end

  def calculate_term_frequency
    tf = {}
    terms.each do |term|
      if tf[term]
        tf[term] += 1
      else
        tf[term] = 1
      end
    end
    total_number_of_terms = terms.size.to_f
    tf.each_pair { |k,v| tf[k] = (tf[k] / total_number_of_terms) }
  end

  def vector_space(corpus)
    vector_space = []
    vector_space_index = 0
    corpus.terms.each_pair do |term, count|
      if has_term?(term)
        vector_space[vector_space_index] = term_frequency[term] * corpus.inverse_document_frequency(term)
      else
        vector_space[vector_space_index] = 0
      end
      vector_space_index += 1
    end
    vector_space
  end

  def has_term?(term)
    terms.include? term
  end
end
