class Document
  attr_reader :content

  def initialize(text)
    @content = text
    @term_frequency = {}
    @terms = nil
  end

  def terms
    @terms ||=
      @content.gsub(/(\d|\s|\W)+/, ' ').
      split(/\s/).map { |term| term.downcase }
  end

  def term_frequency
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

  def has_term?(term)
    terms.include? term
  end
end
