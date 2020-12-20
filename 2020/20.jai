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
    
    match_no_flip := true;
    for 0..9 if a_edge[it] != b_edge[it] { match_no_flip = false; break; }
    if match_no_flip
    {
        array_add(*a.neighbours, b);
        array_add(*b.neighbours, a);
        <<a_used = true;
        <<b_used = true;

        // orient b with a
        if      ae == .TOP && be == .BOT return true; // nothing to do
        else if ae == .BOT && be == .TOP return true; // nothing to do
        else if ae == .LFT && be == .RGT return true; // nothing to do
        else if ae == .RGT && be == .LFT return true; // nothing to do
        else if ae == .TOP && be == .TOP flip_top_and_bottom(b);
        else if ae == .BOT && be == .BOT flip_top_and_bottom(b);
        else if ae == .LFT && be == .LFT flip_left_and_right(b);
        else if ae == .RGT && be == .RGT flip_left_and_right(b);
        else if ae == .TOP && be == .RGT rotate_90_cw(b);
        else if ae == .BOT && be == .LFT rotate_90_cw(b);
        else if ae == .LFT && be == .TOP rotate_90_cw(b);
        else if ae == .RGT && be == .BOT rotate_90_cw(b);
        else if ae == .TOP && be == .LFT rotate_90_ccw(b);
        else if ae == .BOT && be == .RGT rotate_90_ccw(b);
        else if ae == .LFT && be == .BOT rotate_90_ccw(b);
        else if ae == .RGT && be == .TOP rotate_90_ccw(b);

        return true;
    }

    match_with_flip := true;
    for 0..9 if a_edge[it] != b_edge[9-it] { match_with_flip = false; break; }
    if match_with_flip
    {
        array_add(*a.neighbours, b);
        array_add(*b.neighbours, a);
        <<a_used = true;
        <<b_used = true;

        // orient b with a
        if      ae == .TOP && be == .BOT flip_left_and_right(b);
        else if ae == .BOT && be == .TOP flip_left_and_right(b);
        else if ae == .LFT && be == .RGT flip_top_and_bottom(b);
        else if ae == .RGT && be == .LFT flip_top_and_bottom(b);
        else if ae == .TOP && be == .TOP { rotate_90_cw(b); rotate_90_cw(b); }
        else if ae == .BOT && be == .BOT { rotate_90_cw(b); rotate_90_cw(b); }
        else if ae == .LFT && be == .LFT { rotate_90_cw(b); rotate_90_cw(b); }
        else if ae == .RGT && be == .RGT { rotate_90_cw(b); rotate_90_cw(b); }
        else if ae == .TOP && be == .RGT rotate_90_cw(b);
        else if ae == .BOT && be == .LFT rotate_90_cw(b);
        else if ae == .LFT && be == .TOP { rotate_90_cw(b); flip_top_and_bottom(b); }
        else if ae == .RGT && be == .BOT { rotate_90_cw(b); flip_top_and_bottom(b); }
        else if ae == .TOP && be == .LFT { rotate_90_cw(b); flip_top_and_bottom(b); }
        else if ae == .BOT && be == .RGT { rotate_90_cw(b); flip_top_and_bottom(b); }
        else if ae == .LFT && be == .BOT rotate_90_ccw(b);
        else if ae == .RGT && be == .TOP rotate_90_ccw(b);

        return true;
    }

    return false;
}

flip_top_and_bottom :: (t: *Tile)
{
    tempa := t.t_used;
    t.t_used = t.b_used;
    t.b_used = tempa;

    tempb := t.t;
    t.t = t.b;
    t.b = tempb;

    for 0..4
    {
        tempc := t.l[it];
        t.l[it] = t.l[9-it];
        t.l[9-it] = tempc;
        tempd := t.r[it];
        t.r[it] = t.r[9-it];
        t.r[9-it] = tempd;
    }

    for y: 0..3
    {
        for x: 0..7
        {
            tempe := t.image[y][x];
            t.image[y][x] = t.image[7-y][x];
            t.image[7-y][x] = tempe;
        }
    }
}

flip_left_and_right :: (t: *Tile)
{
    tempa := t.r_used;
    t.r_used = t.l_used;
    t.l_used = tempa;

    tempb := t.r;
    t.r = t.l;
    t.l = tempb;

    for 0..4
    {
        tempc := t.t[it];
        t.t[it] = t.t[9-it];
        t.t[9-it] = tempc;
        tempd := t.b[it];
        t.b[it] = t.b[9-it];
        t.b[9-it] = tempd;
    }

    for y: 0..7
    {
        for x: 0..3
        {
            tempe := t.image[y][x];
            t.image[y][x] = t.image[y][7-x];
            t.image[y][7-x] = tempe;
        }
    }
}

rotate_90_cw :: (t: *Tile)
{
    // rotate used
    tempa := t.t_used;
    t.t_used = t.l_used;
    t.l_used = t.b_used;
    t.b_used = t.r_used;
    t.r_used = tempa;

    // rotate borders
    tempb := t.t;
    t.t = t.l; for 0..4 { temp := t.t[it]; t.t[it] = t.t[9-it]; t.t[9-it] = temp; }
    t.l = t.b;
    t.b = t.r; for 0..4 { temp := t.b[it]; t.b[it] = t.b[9-it]; t.b[9-it] = temp; }
    t.r = tempb;

    // rotate inner image
    rotated := t.image;
    for y: 0..7 for x: 0..7 rotated[y][x] = t.image[7 - x][y];
    t.image = rotated;
}

rotate_90_ccw :: (t: *Tile)
{
    rotate_90_cw(t);
    rotate_90_cw(t);
    rotate_90_cw(t);
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