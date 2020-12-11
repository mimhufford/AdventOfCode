day11 :: (input: string) -> string, string
{
    seats1, seats2 := read_map(*input);

    while tick(*seats1, 4) {}
    while tick(*seats2, 5) {}

    part1 := 0; for seats1 if it.occupied_a part1 += 1;
    part2 := 0; for seats2 if it.occupied_a part2 += 1;
    
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Seat :: struct
{
    // TODO collapse into a packed u8
    occupied_a : bool;
    occupied_b : bool;
    neighbours : [..]*Seat;
}

which_go : bool;
width    : s16;
height   : s16;

tick :: (seats: *Table, limit := 0) -> bool
{
    which_go = !which_go;

    work_left := false;

    for * seats
    {
        count := 0;
        if which_go
        {
            for n: it.neighbours if n.occupied_a count += 1;
            if      !it.occupied_a && count == 0     { it.occupied_b = true;  work_left = true; }
            else if  it.occupied_a && count >= limit { it.occupied_b = false; work_left = true; }
            else it.occupied_b = it.occupied_a;
        }
        else
        {
            for n: it.neighbours if n.occupied_b count += 1;
            if      !it.occupied_b && count == 0     { it.occupied_a = true;  work_left = true; }
            else if  it.occupied_b && count >= limit { it.occupied_a = false; work_left = true; }
            else it.occupied_a = it.occupied_b;
        }
    }

    return work_left;
}

read_map :: (input: *string) -> Table(s16, Seat), Table(s16, Seat)
{
    width  = 0;
    height = 1;
    map : [..]u8;

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

    for map if it == #char "L" {
        table_add(*seats1, xx it_index, .{});
        table_add(*seats2, xx it_index, .{});
    } 

    for char, i: map
    {
        if char != #char "L" continue;

        n1, n2 : *Seat;
        s1 := table_find_pointer(seats1, xx i);
        s2 := table_find_pointer(seats2, xx i);

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

neighbour :: (seats1: Table(s16, Seat), seats2: Table(s16, Seat), index: s16, dx: s8, dy: s8) -> *Seat, *Seat
{
    x := index % width + dx;
    y := index / width + dy;
    i := 0;

    while x >= 0 && x < width && y >= 0 && y < height
    {
        sp1 := table_find_pointer(seats1, y*width+x);
        if sp1 
        {
            sp2 := table_find_pointer(seats2, y*width+x);
            if i == 0 return sp1,  sp2;
            else      return null, sp2;
        }
        x += dx;
        y += dy;
        i += 1;
    }

    return null, null;
}