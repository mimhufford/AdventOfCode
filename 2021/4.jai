day4 :: (data : string) -> string, string
{
    numbers := parse_numbers(*data);
    boards  := parse_boards(*data);

    first, last : u64;

    for n : numbers
    {
        for * b : boards
        {
            score := mark_and_check_win(b, n);
            if score
            {
                if !first  first = score;
                else        last = score;

                remove b;
            }
        }
    }

    return tprint("%", first), tprint("%", last);
}

Board :: struct { board : [25]u8; }

mark_and_check_win :: (using b: *Board, n: u8) -> u64
{
    mark   :: (b: *Board, n: u8)         #expand {        b.board[n] |= 0b1000_0000; }
    marked :: (b: *Board, n: u8) -> bool #expand { return b.board[n] &  0b1000_0000 != 0; }

    for 0..cast(u8)24
    {
        if board[it] != n continue;
        mark(b, it);
        break;
    }

    if marked(b,  0) && marked(b,  1) && marked(b,  2) && marked(b,  3) && marked(b,  4) ||
       marked(b,  5) && marked(b,  6) && marked(b,  7) && marked(b,  8) && marked(b,  9) ||
       marked(b, 10) && marked(b, 11) && marked(b, 12) && marked(b, 13) && marked(b, 14) ||
       marked(b, 15) && marked(b, 16) && marked(b, 17) && marked(b, 18) && marked(b, 19) ||
       marked(b, 20) && marked(b, 21) && marked(b, 22) && marked(b, 23) && marked(b, 24) ||
       marked(b,  0) && marked(b,  5) && marked(b, 10) && marked(b, 15) && marked(b, 20) ||
       marked(b,  1) && marked(b,  6) && marked(b, 11) && marked(b, 16) && marked(b, 21) ||
       marked(b,  2) && marked(b,  7) && marked(b, 12) && marked(b, 17) && marked(b, 22) ||
       marked(b,  3) && marked(b,  8) && marked(b, 13) && marked(b, 18) && marked(b, 23) ||
       marked(b,  4) && marked(b,  9) && marked(b, 14) && marked(b, 19) && marked(b, 24)
    {
        unmarked_total : u64;
        for 0..cast(u8)24  if !marked(b, it)  unmarked_total += board[it];
        return n * unmarked_total;
    }

    return 0;
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

        for 0..24
        {
            ten := s.data[0];
            num := s.data[1] - #char "0";
            advance(s, 3);
            if ten != #char " " num += (ten - #char "0") * 10;
            board.board[it] = num;
        }

        if s.count  advance(s, 1);

        array_add(*boards, board);
    }

    return boards;
}