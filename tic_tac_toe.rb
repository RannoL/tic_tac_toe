class Board
  @@walls = ['||', '|', '|', '|| ']
  @@cell_index = 1
  @@row_value = ''
  @@rows = {
    header:"_____________________",
    row1:"",
    row2:"",
    row3:"",
    footer:"---------------------"
    }

  def self.make_board
    for row in 1...4
      @@walls.each do |wall|
        @@row_value += wall
        if wall == @@walls.last
          @@rows["row#{row}".to_sym] = @@row_value
          @@row_value = ""
          next
        end
        @@row_value += "  #{@@cell_index}  "
        @@cell_index += 1
      end
    end
    @@rows.each_value do |row|
      puts row
      puts "---------------------"
    end
  end
end

Board.make_board