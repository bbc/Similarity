class Document
  attr_reader :content, :id

  def initialize(hash_args)
    content = hash_args[:content]
    if content && !content.empty?
      @content = content
      @term_frequency = nil
      @terms = nil
    else
      raise ArgumentError, "text cannot be nil or blank"
    end

    id = hash_args[:id]
    if id && !id.nil?
      @id = id
    else
      @id = self.object_id
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
    tf = Hash.new(0)

    terms.each { |term| tf[term] += 1 }

    total_number_of_terms = terms.size.to_f
    tf.each_pair { |k,v| tf[k] = (tf[k] / total_number_of_terms) }
  end

  def term_frequency(term)
    term_frequencies[term]
  end

  def has_term?(term)
    terms.include? term
  end
end
