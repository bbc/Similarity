require 'rubygems'
require 'faker'
require 'benchmark'

require_relative '../lib/tf-idf'

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
