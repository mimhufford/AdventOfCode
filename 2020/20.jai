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

            if      !a.t_used && !b.t_used && is_match(a, b, .TOP, .TOP) {}
            else if !a.t_used && !b.b_used && is_match(a, b, .TOP, .BOT) {}
            else if !a.t_used && !b.r_used && is_match(a, b, .TOP, .RGT) {}
            else if !a.t_used && !b.l_used && is_match(a, b, .TOP, .LFT) {}
            else if !a.b_used && !b.t_used && is_match(a, b, .BOT, .TOP) {}
            else if !a.b_used && !b.b_used && is_match(a, b, .BOT, .BOT) {}
            else if !a.b_used && !b.r_used && is_match(a, b, .BOT, .RGT) {}
            else if !a.b_used && !b.l_used && is_match(a, b, .BOT, .LFT) {}
            else if !a.r_used && !b.t_used && is_match(a, b, .RGT, .TOP) {}
            else if !a.r_used && !b.b_used && is_match(a, b, .RGT, .BOT) {}
            else if !a.r_used && !b.r_used && is_match(a, b, .RGT, .RGT) {}
            else if !a.r_used && !b.l_used && is_match(a, b, .RGT, .LFT) {}
            else if !a.l_used && !b.t_used && is_match(a, b, .LFT, .TOP) {}
            else if !a.l_used && !b.b_used && is_match(a, b, .LFT, .BOT) {}
            else if !a.l_used && !b.r_used && is_match(a, b, .LFT, .RGT) {}
            else if !a.l_used && !b.l_used && is_match(a, b, .LFT, .LFT) {}
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

Edge :: enum u8 { TOP; BOT; LFT; RGT; }

is_match :: (a: *Tile, b: *Tile, ae: Edge, be: Edge) -> bool
{
    a_edge, b_edge : []bool;
    a_used, b_used : *bool;
    if      ae == .TOP { a_edge = a.t; a_used = *a.t_used; }
    else if ae == .BOT { a_edge = a.b; a_used = *a.b_used; }
    else if ae == .LFT { a_edge = a.l; a_used = *a.l_used; }
    else if ae == .RGT { a_edge = a.r; a_used = *a.r_used; }
    if      be == .TOP { b_edge = b.t; b_used = *b.t_used; }
    else if be == .BOT { b_edge = b.b; b_used = *b.b_used; }
    else if be == .LFT { b_edge = b.l; b_used = *b.l_used; }
    else if be == .RGT { b_edge = b.r; b_used = *b.r_used; }
    
    match := true;
    for 0..9 if a_edge[it] != b_edge[it] { match = false; break; }
    if match
    {
        array_add(*a.neighbours, b);
        array_add(*b.neighbours, a);
        <<a_used = true;
        <<b_used = true;
        return true;
    }
    match = true;
    for 0..9 if a_edge[it] != b_edge[9-it] { match = false; break; }
    if match
    {
        array_add(*a.neighbours, b);
        array_add(*b.neighbours, a);
        <<a_used = true;
        <<b_used = true;
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