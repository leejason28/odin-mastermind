class Board

  attr_accessor :guesses, :hints, :master

  def initialize
    @guesses = Array.new(12) {Guess.new(nil,nil,nil,nil)}
    @hints = Array.new(12) {Hint.new(nil,nil,nil)}

    @current_round = 0
    @colors = ['red', 'green', 'blue', 'yellow', 'pink', 'orange', 'blank']
    @master = generate_code
    @game_over = false
  end

  def generate_code
    code = []
    for i in 0..3
      code.push(@colors[Random.rand(7)])
    end
    code
  end

  def generate_hint(guess)
    pegs = [0, 0]
    master_copy = []
    guess_copy = []
    for i in 0..3
      master_copy.push(@master[i])
      guess_copy.push(guess.code[i])
    end
    offset = 0
    for i in 0..3
      if guess.code[i] == @master[i]
        pegs[1] += 1
        master_copy.delete_at(i-offset)
        guess_copy.delete_at(i-offset)
        offset += 1
      end
    end
    #for i in 0..guess_copy.length
      #if master_copy.include?(guess_copy[i])
        #pegs[0] += 1
      #end
    #end
    guess_copy.each do |color|
      ind = master_copy.index(color)
      if ind
        master_copy.delete_at(ind)
      end
    end
    pegs[0] += (4 - master_copy.length - pegs[1])
    if pegs[1] == 4
      @game_over = true
    end
    Hint.new(guess.code, @master, pegs)
  end

  def play
    p "Welcome to Mastermind. Try to guess the right color code within 12 tries."
    p "Duplicates and blanks are allowed."
    self.output_gamestate
    while @game_over == false
      p "Make a guess. A valid guess comes in the form 'color1 color2 color3 color4'." 
      p "The color options are: red, green, blue, yellow, pink, orange, or blank."
      user_input = gets
      user_code = user_input.split
      user_guess = Guess.new(user_code[0], user_code[1], user_code[2], user_code[3])
      @guesses[@current_round] = user_guess
      @hints[@current_round] = self.generate_hint(user_guess)
      @current_round += 1
      if @current_round == 12
        @game_over = true
      end
      self.output_gamestate
    end
    if @current_round == 12
      p "You lose."
    else
      p "You win!"
    end
  end

  def output_gamestate
    for i in 0..11
      p [@guesses[i].code, @hints[i].pegs]
    end
  end

end

class Guess

  attr_reader :code

  def initialize(c1,c2,c3,c4)
    @code = [c1,c2,c3,c4]
  end

end

class Hint

  attr_reader :pegs, :guess, :master

  def initialize(guess, master, pegs)
    @pegs = pegs
    @guess = guess
    @master = master
  end

end

#b = Board.new
#g = Guess.new('blue', 'red', 'green', 'yellow')
#b.guesses[0] = g
#h = b.generate_hint(b.guesses[0])
#b.hints[0] = h
#b.output_gamestate

#b2 = Board.new
#b2.master = ['red', 'green', 'blue', 'yellow']
#g2 = Guess.new('red', 'yellow', 'blue', 'red')
#user_input = gets
#p user_input
#user_code = user_input.split
#p user_code
#user_guess = Guess.new(user_code[0].to_s, user_code[1].to_s, user_code[2].to_s, user_code[3].to_s)
#h2 = b2.generate_hint(user_guess)
#p h2
#h3 = b2.generate_hint(g2)
#p h3

b3 = Board.new
b3.play