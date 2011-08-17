require 'rubygems'
require 'faker'

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'similarity'

# Perform a benchmark of calculating the whole similarity matrix for a
# corpus of N documents. This isn't a great benchmark since
# Faker::Lorem generates random text from a fixed set of words
# (therefore the total number of terms in the corpus is small), but
# it's a start.

def calculate_similarites(number_of_documents)
  corpus = Corpus.new

  number_of_documents.times do
    document = Document.new(:content => Faker::Lorem.paragraphs.join(' '))
    corpus << document
  end

  corpus.similarity_matrix
end

def time_method(n=1, &blk)
  beginning_time = Time.now
  n.times { yield }
  end_time = Time.now

  elapsed_time = end_time - beginning_time
  puts "Total time elapsed #{elapsed_time}s"
  puts "Average per call: #{elapsed_time / n}s"
end

time_method(5) do
  calculate_similarites(100)
end
