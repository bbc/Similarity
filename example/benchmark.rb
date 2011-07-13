require 'rubygems'
require 'faker'
require 'benchmark'

require_relative '../lib/tf-idf'

# Perform a benchmark of calculating the whole similarity matrix for a
# corpus of N documents. This isn't a great benchmark since
# Faker::Lorem generates random text from a fixed set of words
# (therefore the total number of terms in the corpus is small), but
# it's a start.

def calculate_similarites(number_of_documents)
  corpus = Corpus.new

  # Generate 100 random documents
  documents = []

  number_of_documents.times do
    document = Document.new(Faker::Lorem.paragraphs.join(' '))
    documents << document
    corpus << document
  end

  # Calculate the similarity between every document
  documents.each do |doc1|
    documents.each do |doc2|
      corpus.similarity(doc1, doc2)
    end
  end
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
