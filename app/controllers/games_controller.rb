require 'open-uri'
require 'JSON'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)] }.join.split(//)
  end

  def score
    word = params[:question]
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    json = open(url).read
    objs = JSON.parse(json) 
    isEnglish = objs["found"]
    letters = params[:letters]
    included = true
    word.split(//).each { |char| 
        index = letters.index(char)
        if (!index.nil?)
          letter = eliminate(letters, index)
        else
          included = false
        end
      }
    length = word.length()
    score = 0
    if (isEnglish && included)
      @result = "The word is valid according to the grid and is an English word"
      score = length * length
      if (session[:total_score].nil?)
        session[:total_score] = 0
        @total_score = score
      else
        @total_score = session[:total_score] + score
      end
      
      session[:total_score] = @total_score
    elsif (!isEnglish && included)
      @result = "The word is valid according to the grid, but is not a valid English word"
    else
      @result = "The word can’t be built out of the original grid"
    end
    
  end

  def eliminate(lttrs, idx)
    new_array = []
    lttrs.split(//).each_with_index { |item, index|
      if (index != idx)
        new_array[index] = item
      end
    }
    new_array.join
  end
end
