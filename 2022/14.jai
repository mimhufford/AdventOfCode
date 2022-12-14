day14 :: (input: string) -> string, string
{
    map, floor := parse_map(input);

    first_floor_hit, source_blocked : s64;

    for count: 0..S64_MAX
    {
        sx, sy := 500, -1;

        while true
        {
            if !first_floor_hit && sy+1 == floor
            { 
                first_floor_hit = count;
            }

            if map[0][500] == 2
            { 
                source_blocked = count;
                break count;
            }

            if      map[sy+1][sx  ] == 0 { sy += 1;          }
            else if map[sy+1][sx-1] == 0 { sy += 1; sx -= 1; }
            else if map[sy+1][sx+1] == 0 { sy += 1; sx += 1; }
            else                         { break;            }
        }

        map[sy][sx] = 2;
    }

    return tprint("%", first_floor_hit), tprint("%", source_blocked);
}

#scope_file

COLS :: 1000;
ROWS :: 200;

parse_map :: (input: string) -> [ROWS][COLS]u8, s16
{
    map : [ROWS][COLS]u8;
    floor : s16;

    while input
    {
        first := true;
        pre_x : s16;
        pre_y : s16;

        while input[0] != #char "\n"
        {
            new_x := read_number(s16, *input);
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
            floor = max(floor, new_y + 2);
        }
        advance(*input);
    }

    for 0..COLS-1 map[floor][it] = 1;

    return map, floor;
}