day24 :: (input: string) -> string, string
{
    map, w, h, cycle := generate_map_for_each_cycle(input);

    return tprint("%", ""), tprint("%", "");
}

#scope_file

generate_map_for_each_cycle :: (input: string) -> [..][..][..]u8, s64, s64, s64
{
    map : [..][..][..]u8; // time, y, x
    _ := array_add(*map); // add entry for time = 0

    while input
    {
        row := array_add(*map[0]);

        while true
        {
            defer advance(*input);

            if input[0] == {
                case #char "."; array_add(row, 0);
                case #char "#"; array_add(row, X);
                case #char "<"; array_add(row, L);
                case #char ">"; array_add(row, R);
                case #char "^"; array_add(row, U);
                case #char "v"; array_add(row, D);
                case; break;
            }
        }
    }

    w, h := map[0][0].count, map[0].count;

    cycle := lcm(w-2, h-2);

    for 1..cycle-1
    {
        time := array_add(*map);

        // add everything as walkable to start with
        for prev_row: map[it-1] array_resize(array_add(time), prev_row.count);

        // now update with new positions
        for prev_row, y: map[it-1]
        {
            for prev_col, x: prev_row
            {
                if prev_col & X then (<<time)[ y ][ x ] |= X;
                if prev_col & L { if x > 1   then (<<time)[ y ][x-1] |= L; else (<<time)[ y ][w-2] |= L; }
                if prev_col & R { if x < w-2 then (<<time)[ y ][x+1] |= R; else (<<time)[ y ][ 1 ] |= R; }
                if prev_col & U { if y > 1   then (<<time)[y-1][ x ] |= U; else (<<time)[h-2][ x ] |= U; }
                if prev_col & D { if y < h-2 then (<<time)[y+1][ x ] |= D; else (<<time)[ 1 ][ x ] |= D; }
            }
        }
    }

    return map, w, h, cycle;
}

X :: 0b_1111_0000;
L :: 0b_0000_0001;
R :: 0b_0000_0010;
U :: 0b_0000_0100;
D :: 0b_0000_1000;

lcm :: (a: s64, b: s64) -> s64 { return a / gcd(a, b) * b; }
gcd :: (a: s64, b: s64) -> s64 { if b return gcd(b, a % b); return a; };