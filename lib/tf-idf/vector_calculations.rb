module VectorCalculations
  # http://nlp.stanford.edu/IR-book/html/htmledition/dot-products-1.html
  def self.cosine_similarity(vector1, vector2)
    (dot_product(vector1, vector2)) /
      (abs(vector1) * abs(vector2)).to_f
  end

  def self.abs(vector)
    sum = 0
    for i in 0...vector.size
      sum += (vector[i] ** 2)
    end
    Math.sqrt(sum)
  end

  def self.dot_product(v1, v2)
    sum = 0
    for i in 0...v1.size
        sum += v1[i] * v2[i]
    end
    sum
  end
end
