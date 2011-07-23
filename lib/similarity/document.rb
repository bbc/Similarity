class Document
  attr_reader :content

  def initialize(text)
    if text && !text.empty?
      @content = text
      @term_frequency = nil
      @terms = nil
    else
      raise ArgumentError, "text cannot be nil or blank"
    end
  end

  def terms
    @terms ||=
      @content.gsub(/(\d|\s|\W)+/, ' ').
      split(/\s/).map { |term| term.downcase }
  end

  def term_frequencies
    @term_frequencies ||= calculate_term_frequencies
  end

  def calculate_term_frequencies
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

  def term_frequency(term)
    if tf = term_frequencies[term]
      tf
    else
      0
    end
  end

  def has_term?(term)
    terms.include? term
  end
end
