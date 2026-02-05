day11 :: (input: string) -> string, string
{
    seats1, seats2 := read_map(*input);

    part1 := 0;
    t1d := false;
    while tick(*seats1, 4, t1d) { t1d = !t1d; }
    for seats1 if it.occupied[0] part1 += 1;

    part2 := 0;
    t2d := false;
    while tick(*seats2, 5, t2d) { t2d = !t2d; }
    for seats2 if it.occupied[0] part2 += 1;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Seat :: struct
{
    // TODO collapse into a packed u8
    occupied   : [2]bool;
    neighbours : [..]*Seat;
}

width    : s16;
height   : s16;

tick :: inline (seats: *Table, limit := 0, which_go: bool) -> bool
{
    work_left := false;
    a := ifx which_go then 0 else 1;
    b := 1 - a;

    for * seats
    {
        count := 0;
        for n: it.neighbours if n.occupied[a] count += 1;
        if      !it.occupied[a] && count == 0     { it.occupied[b] = true;  work_left = true; }
        else if  it.occupied[a] && count >= limit { it.occupied[b] = false; work_left = true; }
        else it.occupied[b] = it.occupied[a];
    }

    return work_left;
}

read_map :: inline (input: *string) -> Table(s16, Seat), Table(s16, Seat)
{
    width  = 0;
    height = 1;
    map : [..]u8;
    array_reserve(*map, 100*100);

    while input.count
    {
        if input.data[0] == #char "\n"
        {
            width = 0;
            height += 1;
            advance(input, 1);
            continue;
        }

        width += 1;
        array_add(*map, input.data[0]);
        if input.count advance(input, 1);
    }

    seats1, seats2: Table(s16, Seat);
    init(*seats1, map.count);
    init(*seats2, map.count);

    for map if it == #char "L" {
        table_add(*seats1, xx it_index, .{});
        table_add(*seats2, xx it_index, .{});
    } 

    for char, i: map
    {
        if char != #char "L" continue;

        n1, n2 : *Seat;
        s1 := table_find_pointer(*seats1, xx i);
        s2 := table_find_pointer(*seats2, xx i);

        n1, n2 = neighbour(seats1, seats2, xx i, +1, +0); if n1 array_add(*s1.neighbours, n1); if n2 array_add(*s2.neighbours, n2);
        n1, n2 = neighbour(seats1, seats2, xx i, +1, +1); if n1 array_add(*s1.neighbours, n1); if n2 array_add(*s2.neighbours, n2);
        n1, n2 = neighbour(seats1, seats2, xx i, +1, -1); if n1 array_add(*s1.neighbours, n1); if n2 array_add(*s2.neighbours, n2);
        n1, n2 = neighbour(seats1, seats2, xx i, -1, +0); if n1 array_add(*s1.neighbours, n1); if n2 array_add(*s2.neighbours, n2);
        n1, n2 = neighbour(seats1, seats2, xx i, -1, +1); if n1 array_add(*s1.neighbours, n1); if n2 array_add(*s2.neighbours, n2);
        n1, n2 = neighbour(seats1, seats2, xx i, -1, -1); if n1 array_add(*s1.neighbours, n1); if n2 array_add(*s2.neighbours, n2);
        n1, n2 = neighbour(seats1, seats2, xx i, +0, -1); if n1 array_add(*s1.neighbours, n1); if n2 array_add(*s2.neighbours, n2);
        n1, n2 = neighbour(seats1, seats2, xx i, +0, +1); if n1 array_add(*s1.neighbours, n1); if n2 array_add(*s2.neighbours, n2);
    }

    return seats1, seats2;
}

neighbour :: inline (seats1: Table(s16, Seat), seats2: Table(s16, Seat), index: s16, dx: s8, dy: s8) -> *Seat, *Seat
{
    x := index % width + dx;
    y := index / width + dy;
    i := 0;

    while x >= 0 && x < width && y >= 0 && y < height
    {
        sp1 := table_find_pointer(*seats1, y*width+x);
        if sp1 
        {
            sp2 := table_find_pointer(*seats2, y*width+x);
            if i == 0 return sp1,  sp2;
            else      return null, sp2;
        }
        x += dx;
        y += dy;
        i += 1;
    }

    return null, null;
}