$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'similarity'

corpus = Corpus.new

doc1 = Document.new(:content => "A document with a lot of additional words some of which are about chunky bacon")
doc2 = Document.new(:content => "Another longer document with many words and again about chunky bacon")
doc3 = Document.new(:content => "Some text that has nothing to do with pork products")

[doc1, doc2, doc3].each { |doc| corpus << doc }
corpus.similar_documents(doc1).each do |doc, similarity|
  puts "Similarity between doc #{doc1.id} and doc #{doc.id} is #{similarity}"
end

similarity_matrix = corpus.similarity_matrix
puts "---"
puts "Cross similarity matrix:"
p similarity_matrix
