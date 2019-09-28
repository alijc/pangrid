# Xml
#
#<?xml?>
#<crossword-compiler-applet >
#  <rectangular-puzzle>
#   <metadata>
#     <title>string</title>
#     <creator>string</creator>
#     <copyright>string</copyright>
#   </metadata>
#
#   <crossword>
#     <grid width="int" height="int">
#       <cell x="int" y="int" solution="char" number="int"></cell>,
#       <cell x="int" y="int" solution="char"></cell>,
#       <cell x="1" y="5" type="block"></cell>,
#     </grid>
#     <clues ordering="normal">
#       <title><b>Across</b></title>
#       <clue word="1" number="1" format="8">string</clue>,
#     </clues>
#     <clues ordering="normal">
#       <title><b>Down</b></title>
#       <clue word="13" number="1" format="4">string</clue>,
#     </clues>
#   </crossword>
# </rectangular-puzzle>
#</crossword-compiler-applet>
     
require 'rexml/document'
include REXML

module Pangrid

class Xml < Plugin

  DESCRIPTION = "Simple XML format"

  def read(data)
    doc = Document.new data
    xw = XWord.new
    root = doc.root

    xw.title = root.elements["*/*/title"].text
    xw.author = root.elements["*/*/creator"].text
    xw.copyright = root.elements["*/*/copyright"].text
    
    grid = root.elements["*/*/grid"]
    xw.height = grid.attributes["height"].to_i
    xw.width = grid.attributes["width"].to_i
    xw.solution = Array.new(xw.height) { Array.new(xw.width) }

    root.each_element('//cell') do |c|
      cell = Cell.new
      if c.attributes["type"]  then cell.solution = '#' #and c.type == "block"
      else       cell.solution = c.attributes["solution"]
      end
      x, y = c.attributes["x"].to_i, c.attributes["y"].to_i
      xw.solution[y-1][x-1] = cell
    end

    across_clues = root.elements["*/*/clues"]
    down_clues = across_clues.next_element

    xw.across_clues = []
    across_clues.each_element('clue') do |clue|
        xw.across_clues << clue.text
    end
    xw.down_clues = []
    down_clues.each_element('clue') do |clue|
        xw.down_clues << clue.text
    end

    
puts xw.inspect
    xw
  end

end

end
