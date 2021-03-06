# Makes,renders,changes and checks the board
class Board
  attr_accessor :rows
  def initialize
    @walls = ['||', '|', '|', '|| ']
    @cell_index = 1
    @row_value = ''
    @rows = { row1:'',
              row2:'',
              row3:'' }
  end

  def winning_combination?(piece)
    if winning_diagonal?(piece) ||
       winning_row?(piece) ||
       winning_column?(piece)
      true
    end
  end

  def make_board
    for row in 1..3
      @walls.each do |wall|
        @row_value += wall
        if wall == @walls.last
          @rows["row#{row}".to_sym] = @row_value
          @row_value = ''
          next
        end
        @row_value += "  #{@cell_index}  "
        @cell_index += 1
      end
    end
  end

  def render_board
    puts
    puts '_____________________'
    @rows.each_value do |row|
      puts row
      puts '---------------------'
    end
    puts
  end

  def find_n_replace_coord(coord, piece)
    for row in 1..3
      if rows["row#{row}".to_sym].include?(coord)
        row_content = rows["row#{row}".to_sym]
        #change the coordinate to players piece
        row_content[coord] = piece.to_s
        rows["row#{row}".to_sym] = row_content
      end
    end
  end

  private

    # Remove borders from the rows hash.
    # Return an 2D array of only the specifed pieces and empty strings.
    def rows_strip(piece)
      # Will be a 2D Array of the rows content. Can be compared to WIN combination.
      stripped_rows = []
      i = 0
      @rows.each_value do |row_str|
        # Delete borders and replace everything but the piece with space.
        row_str = row_str.delete('| ').gsub(/[^"#{piece}"]/, ' ')
        row_arr = row_str.split('')
        stripped_rows[i] = row_arr
        i += 1
      end
      stripped_rows
    end

    def winning_diagonal?(piece)
      piece = piece.to_s
      current_board = rows_strip(piece)
      if current_board[1][1] == ' '
        false
      elsif current_board[0][0] ==
            current_board[1][1] &&
            current_board[1][1] ==
            current_board[2][2]
        puts "winning diagonal1"
        true
      elsif current_board[0][2] ==
            current_board[1][1] &&
            current_board[1][1] ==
            current_board[2][0]
        puts 'winning diagonal2'
        true
      else
        false
      end
    end

    def winning_column?(piece)
      piece = piece.to_s
      current_board = rows_strip(piece)
      for piece in 0...3
        next if current_board[0][piece] == ' '

        # If there is a matching piece on the same index in every row
        # it forms a winning column
        if current_board[0][piece] ==
          current_board[1][piece] &&
          current_board[1][piece] ==
          current_board[2][piece]
          return true
        else
          false
        end
      end
      # Otherwise returns 3, from for loop which equals true in winning_combination
      false
    end

    def winning_row?(piece)
      piece = piece.to_s
      current_board = rows_strip(piece)
      current_board.include?([piece, piece, piece]) ? true : false
    end
end

# Manages the flow of the game
class Game

  def initialize
    require 'io/console' 
    @banner = File.read("banner.txt")
    puts @banner
    puts 'Press any key to continue'
    STDIN.getch
    puts
    start_game
  end

  private

    def start_game
      @board = Board.new
      puts '_____________________'
      @board.make_board
      two_players_play
    end

    def two_players_play
      @player_one = Player.new('Player 1', :X, @board)
      @player_two = Player.new('Player 2', :O, @board)
      @current_player = @player_one
      loop do
        @board.render_board
        @current_player.get_coordinate

        if check_game_over
          break
        end

        switch_players
      end
    end

    def switch_players
      if @current_player == @player_one
        @current_player = @player_two
      else
        @current_player = @player_one
      end
    end

    def check_game_over
      check_victory || check_draw
    end

    def check_victory
      if @board.winning_combination?(@current_player.piece)
        @board.render_board
        puts "#{@current_player.name} wins!"
        puts ''
        true
      else
        false
      end
    end

    def check_draw
      if Player.class_variable_get(:@@made_moves).length >= 9
        puts
        puts "It's a draw."
        puts
        true
      end
    end
end

# Manages players and player input
class Player
  @@made_moves = []
  attr_accessor :name, :piece

  def initialize(name, piece, board)
    @name = name
    @piece = piece
    @board = board
    puts
    puts "#{@name} is #{@piece}"
  end

    # Verify and add to the board
  def get_coordinate
    loop do
      coord = ask_for_coordinate
      if verify_coord(coord)
        @board.find_n_replace_coord(coord, @piece)
        @@made_moves << coord
        break
      end
    end
  end

  private
  
    # Ask for users input
    def ask_for_coordinate
      puts '---------------------'
      puts "#{@name}'s move: "
      gets.chomp
    end

    def verify_coord(coord)
      begin
        coord = Integer(coord)

        if @@made_moves.include?(coord)
          puts 'Already occupied!'
        elsif coord.between?(1, 9)
          true
        else
          puts 'Choose a coordinate from the board between 1 and 9'
        end
      rescue ArgumentError, TypeError
        puts 'Choose a coordinate from the board between 1 and 9'
      end
    end
end

Game.new
