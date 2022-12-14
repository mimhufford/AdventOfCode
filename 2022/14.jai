day14 :: (input: string) -> string, string
{
    map := parse_map(input);
    part1 := drop_sand();

    return tprint("%", part1), tprint("%", "");
}

#scope_file

OFFSET :: 450;
COLS   :: 200;
ROWS   :: 200;

drop_sand :: () -> s64 #expand
{
    for count: 0..S64_MAX
    {
        sx, sy := 500 - OFFSET, 0;

        while true
        {
            if sy+1 >= ROWS               { return count;     }
            else if `map[sy+1][sx  ] == 0 { sy += 1;          }
            else if `map[sy+1][sx-1] == 0 { sy += 1; sx -= 1; }
            else if `map[sy+1][sx+1] == 0 { sy += 1; sx += 1; }
            else                          { break;            }
        }

        `map[sy][sx] = 2;
    }

    assert(false);
    return 0;
}

parse_map :: (input: string) -> [ROWS][COLS]u8
{
    map : [ROWS][COLS]u8;

    while input
    {
        first := true;
        pre_x : s16;
        pre_y : s16;

        while input[0] != #char "\n"
        {
            new_x := read_number(s16, *input) - OFFSET;
            advance(*input);
            new_y := read_number(s16, *input, skip_trailing_whitespace=false);
            if input[0] == #char " " advance(*input, 4);

            if !first
            {
                x1 := min(new_x, pre_x);
                x2 := max(new_x, pre_x);
                y1 := min(new_y, pre_y);
                y2 := max(new_y, pre_y);

                for y: y1..y2 for x: x1..x2  map[y][x] = 1;
            }

            first = false;
            pre_x = new_x;
            pre_y = new_y;
        }
        advance(*input);
    }

    return map;
}