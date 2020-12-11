day11 :: (input: string) -> string, string
{
    seats1, seats2 := read_map(*input);

    while tick(*seats1, 4) {}
    which_go = false;
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
w : s64;
h : s64;

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

read_map :: (input: *string) -> Table(s64, Seat), Table(s64, Seat)
{
    w = 0;
    h = 1;
    map : [..]u8;

    while input.count
    {
        if input.data[0] == #char "\n"
        {
            w = 0;
            h += 1;
            advance(input, 1);
            continue;
        }

        w += 1;
        array_add(*map, input.data[0]);
        if input.count advance(input, 1);
    }

    seats1, seats2: Table(s64, Seat);

    for map if it == #char "L" {
        table_add(*seats1, it_index, .{});
        table_add(*seats2, it_index, .{});
    } 

    for map
    {
        if it != #char "L" continue;

        sp : *Seat;

        s1 := table_find_pointer(seats1, it_index);
        sp = find_neighbour(*seats1, it_index, +1, +0, true); if sp array_add(*s1.neighbours, sp);
        sp = find_neighbour(*seats1, it_index, +1, +1, true); if sp array_add(*s1.neighbours, sp);
        sp = find_neighbour(*seats1, it_index, +1, -1, true); if sp array_add(*s1.neighbours, sp);
        sp = find_neighbour(*seats1, it_index, -1, +0, true); if sp array_add(*s1.neighbours, sp);
        sp = find_neighbour(*seats1, it_index, -1, +1, true); if sp array_add(*s1.neighbours, sp);
        sp = find_neighbour(*seats1, it_index, -1, -1, true); if sp array_add(*s1.neighbours, sp);
        sp = find_neighbour(*seats1, it_index, +0, -1, true); if sp array_add(*s1.neighbours, sp);
        sp = find_neighbour(*seats1, it_index, +0, +1, true); if sp array_add(*s1.neighbours, sp);

        s2 := table_find_pointer(seats2, it_index);
        sp = find_neighbour(*seats2, it_index, +1, +0, false); if sp array_add(*s2.neighbours, sp);
        sp = find_neighbour(*seats2, it_index, +1, +1, false); if sp array_add(*s2.neighbours, sp);
        sp = find_neighbour(*seats2, it_index, +1, -1, false); if sp array_add(*s2.neighbours, sp);
        sp = find_neighbour(*seats2, it_index, -1, +0, false); if sp array_add(*s2.neighbours, sp);
        sp = find_neighbour(*seats2, it_index, -1, +1, false); if sp array_add(*s2.neighbours, sp);
        sp = find_neighbour(*seats2, it_index, -1, -1, false); if sp array_add(*s2.neighbours, sp);
        sp = find_neighbour(*seats2, it_index, +0, -1, false); if sp array_add(*s2.neighbours, sp);
        sp = find_neighbour(*seats2, it_index, +0, +1, false); if sp array_add(*s2.neighbours, sp);
    }

    return seats1, seats2;
}

find_neighbour :: (seats: *Table(s64, Seat), index: s64, dx: s64, dy: s64, once: bool) -> *Seat
{
    x := index % w + dx;
    y := index / w + dy;

    while x >= 0 && x < w && y >= 0 && y < h
    {
        sp := table_find_pointer(<<seats, y*w+x);
        if sp return sp;
        if once return null;
        x += dx;
        y += dy;
    }

    return null;
}