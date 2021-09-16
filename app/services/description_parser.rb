# frozen_string_literal: true

class DescriptionParser
  def self.keywords(description)
    tr = GraphRank::Keywords.new
    tr.run(description)[0...10].map { |pair| pair[0] }
  end
end
