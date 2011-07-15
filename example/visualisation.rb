# -*- coding: utf-8 -*-
require_relative '../lib/tf-idf'
require 'rubygems'
require 'graphviz'

=begin

This example shows how to generate diagrams such as those produced by
Stray and Burgess in:
http://jonathanstray.com/a-full-text-visualization-of-the-iraq-war-logs

It uses the Ruby Graphviz library and the tf-idf gem
=end

# First we define a corpus to hold the documents
corpus = Corpus.new

# Now we add documents to the corpus. Here we're using a few headlines
# from the BBC News RSS feed.

headlines = [
             "Broad powers for hacking inquiry",
             "UK unemployment level falls again",
             "NI riots leads to 26 arrests",
             "IMF urges spending cuts in Italy",
             "UK ticket wins £161m Euromillions",
             "EU proposal to save fish stocks",
             "Pilots cleared by Chinook report",
             "Briton dies in Greece 'stabbing'",
             "'Spy' committee calls for reforms",
             "UK charities step up Somalia aid"
            ]

documents = []
headlines.each do |headline|
  # create a document object from the headline
  document = Document.new(headline)

  # store the document object for later
  documents << document

  # add the document to the corpus
  corpus << document
end

# Print a count of unique terms extracted from the documents
puts "Total number of tems in the corpus: #{corpus.terms.size}"

# Generate a GraphViz graph to hold the results
g = GraphViz.new( :G, :type => :graph )

# A small function to return the n largest entries in a hash by
# value. We'll use this to label our nodes in the final graph.
def n_largest_values(hash, n=3)
  sorted_hash = hash.sort_by { |k,v| v }.reverse
  sorted_hash[0..n-1].map{ |e| e[0] }
end

# Calculate the similarity pairs between all the documents
documents.each_with_index do |doc1, index1|
  documents.each_with_index do |doc2, index2|
    if index1 > index2 # we only need to calculate each pair once

      # Calculate the similarity and return the weights
      similarity, doc1_weights, doc2_weights = corpus.similarity(doc1, doc2, include_weights = true)

      # create the nodes, label them and add an edge with a weight
      # equal to the similarity. We'll include all the nodes as this
      # is a small graph, but you may want to set a threshold on
      # similarity.
      node1_label = n_largest_values(doc1_weights).join(" ")
      node2_label = n_largest_values(doc1_weights).join(" ")

      node1 = g.add_node( doc1.object_id.to_s, "label" => "#{node1_label}" )
      node2 = g.add_node( doc2.object_id.to_s, "label" => "#{node2_label}" )
      g.add_edge(node1, node2, "weight" => similarity)
    end
  end
end

# Output the final graph in DOT format to the current directory. Gephi
# will read this format, or you can use the graphviz tool chain.
g.output(:none => "graph.dot")
