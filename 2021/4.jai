day4 :: (data : string) -> string, string
{
    numbers := parse_numbers(*data);
    boards  := parse_boards(*data);

    first, last : u64;

    for n : numbers
    {
        for * b : boards
        {
            mark_board(b, n);
            won, score := check_for_win(b);
            if won
            {
                if !first  first = score * n;
                else        last = score * n;

                remove b;
            }
        }
    }

    return tprint("%", first), tprint("%", last);
}

Board :: struct
{
    board  : [5][5]u8;
    marked : [5][5]bool;
}

mark_board :: (b: *Board, n: u8)
{
    for row : 0..4
    {
        for col : 0..4
        {
            if b.board[row][col] == n
            {
                b.marked[row][col] = true;
                return;
            }
        }
    }
}

unmarked_total :: (b: *Board) -> u64
{
    total : u64;

    for row : 0..4
    {
        for col : 0..4
        {
            if !b.marked[row][col]
            {
                total += b.board[row][col];
            }
        }
    }

    return total;
}

check_for_win :: (b: *Board) -> bool, u64
{
    for row : 0..4
    {
        all_marked := true;

        for col : 0..4
        {
            if !b.marked[row][col]
            {
                all_marked = false;
                break;
            }
        }
        
        if all_marked  return true, unmarked_total(b);
    }

    for col : 0..4
    {
        all_marked := true;

        for row : 0..4
        {
            if !b.marked[row][col]
            {
                all_marked = false;
                break;
            }
        }
        
        if all_marked  return true, unmarked_total(b);
    }

    return false, 0;
}

parse_numbers :: (s: *string) -> [..]u8
{
    numbers : [..]u8;

    while s.data[0] != #char "\n"
    {
        num : u8;

        while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
        {
            num *= 10;
            num += s.data[0] - #char "0";
            advance(s, 1);
        }

        advance(s, 1);

        array_add(*numbers, num);
    }

    advance(s, 1);
    return numbers;
}

parse_boards :: (s: *string) -> [..]Board
{
    boards : [..]Board;

    while s.count
    {
        board : Board;

        for row : 0..4
        {
            for col : 0..4
            {
                ten := s.data[0];
                num := s.data[1] - #char "0";
                advance(s, 3);
                if ten != #char " " num += (ten - #char "0") * 10;
                board.board[row][col] = num;
            }
        }

        if s.count  advance(s, 1);

        array_add(*boards, board);
    }

    return boards;
}