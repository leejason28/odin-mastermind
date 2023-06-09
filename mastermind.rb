class Board

  attr_accessor :guesses, :hints, :master

  def initialize
    @guesses = Array.new(12) {Guess.new(nil,nil,nil,nil)}
    @hints = Array.new(12) {Hint.new(nil,nil,nil)}

    @current_round = 0
    @colors = ['red', 'green', 'blue', 'yellow', 'pink', 'orange', 'blank']
    @master = generate_code
    @game_over = false
    @codemaker = 'computer'
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
    p "Would you like to be codemaker or codeguesser? Please type 'codemaker' if so. Otherwise, you will be the guesser."
    user_response = gets
    if user_response.gsub("\n","") == 'codemaker'
      @codemaker = 'player'
    end
    self.output_gamestate
    if @codemaker == 'computer'
      while @game_over == false
        p "Make a guess. A valid guess comes in the form 'color1 color2 color3 color4'." 
        p "The color options are: red, green, blue, yellow, pink, orange, or blank."
        user_input = gets
        user_code = user_input.split
        if valid_move?(user_code) == false
          next
        end
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
    else
      p "Make a code. A valid code comes in the form 'color1 color2 color3 color4'." 
      p "The color options are: red, green, blue, yellow, pink, orange, or blank."
      user_input = gets
      user_code = user_input.split
      while valid_move?(user_code) == false
        p "Enter a valid code. A valid code comes in the form 'color1 color2 color3 color4'"
        p "The color options are: red, green, blue, yellow, pink, orange, or blank."
        user_input = gets
        user_code = user_input.split
      end
      user_guess = Guess.new(user_code[0], user_code[1], user_code[2], user_code[3])
      @master = user_guess.code
      while @game_over == false
        comp_code = generate_code
        comp_guess = Guess.new(comp_code[0], comp_code[1], comp_code[2], comp_code[3])
        @guesses[@current_round] = comp_guess
        @hints[@current_round] = self.generate_hint(comp_guess)
        @current_round += 1
        if @current_round == 12
          @game_over = true
        end
        self.output_gamestate
      end
      if @current_round == 12
        p "You win!"
      else
        p "You lose."
      end
    end
  end

  def output_gamestate
    for i in 0..11
      p [@guesses[i].code, @hints[i].pegs]
    end
  end

  def valid_move?(code)
    for i in 0..3
      if @colors.include?(code[i]) == false
        return false
      end
    end
    return true
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

b = Board.new
b.play