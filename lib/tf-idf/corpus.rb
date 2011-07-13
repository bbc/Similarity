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
    document1.vector_space(self).similarity(document2.vector_space(self))
  end
end
