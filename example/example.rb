# -*- coding: utf-8 -*-
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'similarity'

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

# Print a list of unique terms extracted from the documents
puts corpus.terms

# Calculate the similarity matrix between all the documents
puts corpus.similarity_matrix

