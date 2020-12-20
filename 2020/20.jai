day20 :: (input: string) -> string, string
{
    tiles: [..]Tile;

    while input.count {
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
        for y: 1..8 {
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

    for * a: tiles {
        for * b: tiles {
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
    for * tiles if it.neighbours.count == 2 part1 *= it.id;

    image : [12][12]*Tile;

    // find and orient top left tile
    top_left: *Tile;
    for * tiles if it.neighbours.count == 2 { top_left = it; break; }
    while top_left.t_used || top_left.l_used rotate_90_cw(top_left);
    image[0][0] = top_left;

    // fill in the top row based on the one to the left
    for x: 1..image.count-1 {
        a := image[0][x-1];
        for b: a.neighbours {
            if is_match(a, b, .RGT, .TOP) { image[0][x] = b; rotate_90_ccw(b); break; }
            if is_match(a, b, .RGT, .RGT) { image[0][x] = b; flip_left_and_right(b); break; }
            if is_match(a, b, .RGT, .BOT) { image[0][x] = b; rotate_90_cw(b); break; }
            if is_match(a, b, .RGT, .LFT) { image[0][x] = b; break; }
        }
        b := image[0][x]; assert(!!b);
        needs_flip := false;
        for 0..9 if a.r[it] != b.l[it] { needs_flip = true; break; }
        if needs_flip flip_top_and_bottom(b);
    }

    // fill in the rest based on ones above
    for y: 1..image.count-1 {
        for x: 0..image.count-1 {
            a := image[y-1][x];
            for b: a.neighbours {
                if is_match(a, b, .BOT, .TOP) { image[y][x] = b; break; }
                if is_match(a, b, .BOT, .RGT) { image[y][x] = b; rotate_90_ccw(b); break; }
                if is_match(a, b, .BOT, .BOT) { image[y][x] = b; flip_top_and_bottom(b); break; }
                if is_match(a, b, .BOT, .LFT) { image[y][x] = b; rotate_90_cw(b); break; }
            }
            b := image[y][x]; assert(!!b);
            needs_flip := false;
            for 0..9 if a.b[it] != b.t[it] { needs_flip = true; break; }
            if needs_flip flip_left_and_right(b);
        }
    }

    pixels : [12*8][12*8]bool;

    for iy: 0..image.count-1 {
        for ix: 0..image.count-1 {
            for y: 0..7 {
                for x: 0..7 {
                    pixels[iy*8+y][ix*8+x] = image[iy][ix].image[y][x];
                }
            }
        }
    }

    /*
         01234567890123456789
        0..................#.
        1#....##....##....###
        2.#..#..#..#..#..#...
    */

    monster : [3][20]bool;
    monster[0][18] = true; monster[1][ 0] = true; monster[1][ 5] = true;
    monster[1][ 6] = true; monster[1][11] = true; monster[1][12] = true;
    monster[1][17] = true; monster[1][18] = true; monster[1][19] = true;
    monster[2][ 1] = true; monster[2][ 4] = true; monster[2][ 7] = true;
    monster[2][10] = true; monster[2][13] = true; monster[2][16] = true;

    done := false;

    for 1..8 {
        for y: 0..pixels.count-3 {
            for x: 0..pixels.count-20 {
                found := true;

                for my: 0..2 {
                    for mx: 0..19 {
                        if monster[my][mx] && !pixels[y+my][x+mx] {
                            found = false;
                            my = 99;
                            break;
                        }
                    }
                }

                if found done = true;
                if found for my: 0..2 for mx: 0..19 if monster[my][mx] pixels[y+my][x+mx] = false;
            }
        }

        if done break;

        // didn't find any so rotate
        r := pixels;
        for y: 0..r.count-1 for x: 0..r.count-1 r[y][x] = pixels[r.count - 1 - x][y];
        pixels = r;

        // on turn 4 we've rotated without finding, so do a flip
        if it == 4 {
            for y: 0..pixels.count-1 {
                for x: 0..pixels.count/2-1 {
                    temp := pixels[y][x];
                    pixels[y][x] = pixels[y][pixels.count-1-x];
                    pixels[y][pixels.count-1-x] = temp;
                }
            }
        }
    }

    part2 : u64;
    for row: pixels for pixel: row if pixel part2 += 1;

    return tprint("%", part1), tprint("%", part2);
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
    if !match { match = true; for 0..9 if a_edge[it] != b_edge[9-it] { match = false; break; } }
    if !match return false;
    
    array_add(*a.neighbours, b);
    array_add(*b.neighbours, a);
    <<a_used = true;
    <<b_used = true;
    return true;
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