day20 :: (input: string) -> string, string
{
    tiles: [..]Tile;

    while input.count
    {
        tile: Tile;
        advance(*input, 5); // "Tile "
        tile.id = read_number(*input);
        advance(*input, 2); // ":\n"

        // top row and first one of left and right
        tile.l[0] = input[0] == #char "#";
        for 0..8 { tile.t[it] = input[0] == #char "#"; advance(*input); }
        tile.r[0] = input[0] == #char "#";
        tile.t[9] = input[0] == #char "#";
        advance(*input, 2);

        // left and right rows except bottom bits
        for y: 1..8
        {
            tile.l[y] = input[0] == #char "#";
            advance(*input);
            for x: 0..7 { tile.image[y-1][x] = input[0] == #char "#"; advance(*input); } 
            tile.r[y] = input[0] == #char "#";
            advance(*input, 2);
        }

        // bottom row and last one of left and right
        tile.l[9] = input[0] == #char "#";
        for 0..8 { tile.b[it] = input[0] == #char "#"; advance(*input); }
        tile.r[9] = input[0] == #char "#";
        tile.b[9] = input[0] == #char "#";

        advance(*input);
        if input.count advance(*input, 2);
        array_add(*tiles, tile);
    }

    for * a: tiles
    {
        for * b: tiles
        {
            if a == b continue;

            if      !a.t_used && !b.t_used && is_match(a, b, a.t, b.t) { a.t_used = true; b.t_used = true; }
            else if !a.t_used && !b.b_used && is_match(a, b, a.t, b.b) { a.t_used = true; b.b_used = true; }
            else if !a.t_used && !b.r_used && is_match(a, b, a.t, b.r) { a.t_used = true; b.r_used = true; }
            else if !a.t_used && !b.l_used && is_match(a, b, a.t, b.l) { a.t_used = true; b.l_used = true; }
            else if !a.b_used && !b.t_used && is_match(a, b, a.b, b.t) { a.b_used = true; b.t_used = true; }
            else if !a.b_used && !b.b_used && is_match(a, b, a.b, b.b) { a.b_used = true; b.b_used = true; }
            else if !a.b_used && !b.r_used && is_match(a, b, a.b, b.r) { a.b_used = true; b.r_used = true; }
            else if !a.b_used && !b.l_used && is_match(a, b, a.b, b.l) { a.b_used = true; b.l_used = true; }
            else if !a.r_used && !b.t_used && is_match(a, b, a.r, b.t) { a.r_used = true; b.t_used = true; }
            else if !a.r_used && !b.b_used && is_match(a, b, a.r, b.b) { a.r_used = true; b.b_used = true; }
            else if !a.r_used && !b.r_used && is_match(a, b, a.r, b.r) { a.r_used = true; b.r_used = true; }
            else if !a.r_used && !b.l_used && is_match(a, b, a.r, b.l) { a.r_used = true; b.l_used = true; }
            else if !a.l_used && !b.t_used && is_match(a, b, a.l, b.t) { a.l_used = true; b.t_used = true; }
            else if !a.l_used && !b.b_used && is_match(a, b, a.l, b.b) { a.l_used = true; b.b_used = true; }
            else if !a.l_used && !b.r_used && is_match(a, b, a.l, b.r) { a.l_used = true; b.r_used = true; }
            else if !a.l_used && !b.l_used && is_match(a, b, a.l, b.l) { a.l_used = true; b.l_used = true; }
        }
    }

    part1 : u64 = 1;

    for tiles
    {
        used_edges : u8;
        if it.t_used used_edges += 1;
        if it.b_used used_edges += 1;
        if it.r_used used_edges += 1;
        if it.l_used used_edges += 1;
        if used_edges == 2 part1 *= it.id;
    }

    return tprint("%", part1), "";
}

#scope_file

Tile :: struct
{
    id: u16;
    t, b, l, r: [10]bool;
    image: [8][8]bool;
    t_used, b_used, l_used, r_used: bool;
    neighbours: [..]*Tile;
}

is_match :: (a: *Tile, b: *Tile, a_edge: []bool, b_edge: []bool) -> bool
{
    match := true;
    for 0..9 if a_edge[it] != b_edge[it] { match = false; break; }
    if match
    {
        array_add(*a.neighbours, b);
        array_add(*b.neighbours, a);
        return true;
    }
    match = true;
    for 0..9 if a_edge[it] != b_edge[9-it] { match = false; break; }
    if match
    {
        array_add(*a.neighbours, b);
        array_add(*b.neighbours, a);
        return true;
    }
    return false;
}

read_number :: (s: *string) -> u16
{
    num: u16;

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s);
    }

    return num;
}