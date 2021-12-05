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

Board :: struct
{
    board  : [25]u8;
    marked : [25]bool;
}

mark_and_check_win :: (b: *Board, n: u8) -> u64
{
    for 0..24
    {
        if b.board[it] == n
        {
            b.marked[it] = true;
            break;
        }
    }

    if b.marked[ 0] && b.marked[ 1] && b.marked[ 2] && b.marked[ 3] && b.marked[ 4] ||
       b.marked[ 5] && b.marked[ 6] && b.marked[ 7] && b.marked[ 8] && b.marked[ 9] ||
       b.marked[10] && b.marked[11] && b.marked[12] && b.marked[13] && b.marked[14] ||
       b.marked[15] && b.marked[16] && b.marked[17] && b.marked[18] && b.marked[19] ||
       b.marked[20] && b.marked[21] && b.marked[22] && b.marked[23] && b.marked[24] ||
       b.marked[ 0] && b.marked[ 5] && b.marked[10] && b.marked[15] && b.marked[20] ||
       b.marked[ 1] && b.marked[ 6] && b.marked[11] && b.marked[16] && b.marked[21] ||
       b.marked[ 2] && b.marked[ 7] && b.marked[12] && b.marked[17] && b.marked[22] ||
       b.marked[ 3] && b.marked[ 8] && b.marked[13] && b.marked[18] && b.marked[23] ||
       b.marked[ 4] && b.marked[ 9] && b.marked[14] && b.marked[19] && b.marked[24]
    {
        unmarked_total : u64;
        for 0..24  if !b.marked[it]  unmarked_total += b.board[it];
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