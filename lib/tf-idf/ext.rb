class Array

  # http://nlp.stanford.edu/IR-book/html/htmledition/dot-products-1.html
  def similarity(other_array)
    (self.dot_product(other_array)) / (self.abs * other_array.abs).to_f
  end

  def abs
    sum = 0
    for i in 0...self.size
      sum += (self[i] ** 2)
    end
    Math.sqrt(sum)
  end

  def dot_product(other)
    sum = 0
    for i in 0...self.size
        sum += self[i] * other[i]
    end
    sum
  end
end
