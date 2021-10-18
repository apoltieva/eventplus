# frozen_string_literal: true

class DescriptionParser
  # TODO: add stemmer, check stopwords
  def self.keywords(description)
    tr = GraphRank::Keywords.new
    tr.stop_words = Stopwords::STOP_WORDS << 'just'
    Timeout::timeout(5) { tr.run(description)[0...10].map { |pair| pair[0] } }
  rescue Timeout::Error
    []
  end
end
