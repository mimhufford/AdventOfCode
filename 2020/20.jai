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
        for 1..8
        {
            tile.l[it] = input[0] == #char "#";
            advance(*input, 9);
            tile.r[it] = input[0] == #char "#";
            advance(*input, 2);
        }

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
        if a.t_used continue;

        for * b: tiles
        {
            if a == b continue;

            if is_match(a.t, b.t)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.t_used = true;
                b.t_used = true;
            }
            else if is_match(a.t, b.b)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.t_used = true;
                b.b_used = true;
            }
            else if is_match(a.t, b.r)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.t_used = true;
                b.r_used = true;
            }
            else if is_match(a.t, b.l)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.t_used = true;
                b.l_used = true;
            }
        }
    }
    for * a: tiles
    {
        if a.b_used continue;

        for * b: tiles
        {
            if a == b continue;

            if is_match(a.b, b.t)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.b_used = true;
                b.t_used = true;
            }
            else if is_match(a.b, b.b)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.b_used = true;
                b.b_used = true;
            }
            else if is_match(a.b, b.r)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.b_used = true;
                b.r_used = true;
            }
            else if is_match(a.b, b.l)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.b_used = true;
                b.l_used = true;
            }
        }
    }
    for * a: tiles
    {
        if a.r_used continue;

        for * b: tiles
        {
            if a == b continue;

            if is_match(a.r, b.t)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.r_used = true;
                b.t_used = true;
            }
            else if is_match(a.r, b.b)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.r_used = true;
                b.b_used = true;
            }
            else if is_match(a.r, b.r)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.r_used = true;
                b.r_used = true;
            }
            else if is_match(a.r, b.l)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.r_used = true;
                b.l_used = true;
            }
        }
    }
    for * a: tiles
    {
        if a.l_used continue;

        for * b: tiles
        {
            if a == b continue;

            if is_match(a.l, b.t)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.l_used = true;
                b.t_used = true;
            }
            else if is_match(a.l, b.b)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.l_used = true;
                b.b_used = true;
            }
            else if is_match(a.l, b.r)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.l_used = true;
                b.r_used = true;
            }
            else if is_match(a.l, b.l)
            {
                array_add(*a.neighbours, b);
                array_add(*b.neighbours, a);
                a.l_used = true;
                b.l_used = true;
            }
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
    t_used, b_used, l_used, r_used: bool;
    neighbours: [..]*Tile;
}

is_match :: (a: []bool, b: []bool) -> bool
{
    match := true;
    for 0..9 if a[it] != b[it] { match = false; break; }
    if match return true;
    match = true;
    for 0..9 if a[it] != b[9-it] { match = false; break; }
    return match;
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