day23 :: (input: string) -> string, string
{
    while input
    {
        a := input; a.count = 2; advance(*input, 3);
        b := input; b.count = 2; advance(*input, 3);

        ai, bi := get_id(a), get_id(b);
        
        array_add_if_unique(*connections[ai], bi);
        array_add_if_unique(*connections[bi], ai);
    }

    part1, part2 := find_t_triplets(), find_largest_bunch_of_nerds();

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

connections : [26*26] [..]s64;
largest_bunch_of_nerds : [..]s64;

find_t_triplets :: () -> s64
{
    triplets : [..]s64;

    for t: get_id("ta")..get_id("tz")
    {
        if connections[t].count == 0 continue;

        for i: 0..connections[t].count-1
        {
            for j: i+1..connections[t].count-1
            {
                a := connections[t][i];
                b := connections[t][j];
                if !array_find(connections[a], t) continue;
                if !array_find(connections[a], b) continue;
                if !array_find(connections[b], t) continue;
                if !array_find(connections[b], a) continue;
                array_add_if_unique(*triplets, get_triplet_id(t, a, b));
            }
        }
    }

    return triplets.count;
}

find_largest_bunch_of_nerds :: () -> s64
{
    bron_kerbosch :: (r: [..]s64, _p: [..]s64, _x: [..]s64)
    {
        if !_p.count && !_x.count
        {
            if r.count <= largest_bunch_of_nerds.count return;
            array_reset_keeping_memory(*largest_bunch_of_nerds);
            array_add(*largest_bunch_of_nerds, ..r);
            return;
        }

        p : [..]s64; array_add(*p, .._p);
        x : [..]s64; array_add(*x, .._x);

        for v: p
        {
            nr : [..]s64;
            array_add(*nr, ..r);
            array_add(*nr, v);
            np : [..]s64;
            for p if array_find(connections[v], it) array_add(*np, it);
            nx : [..]s64;
            for x if array_find(connections[v], it) array_add(*nx, it);
            bron_kerbosch(nr, np, nx);

            remove v;
            array_add(*x, v);
        }
    }

    r, p, x : [..]s64;
    for connections if it.count array_add(*p, it_index);
    bron_kerbosch(r, p, x);

    return largest_bunch_of_nerds.count;
}

get_id :: (computer: string) -> s64
{
    return cast(s64)(computer[0] - #char "a") * 26 + cast(s64)(computer[1] - #char "a");
}

get_triplet_id :: (a: s64, b: s64, c: s64) -> s64
{
    ids := s64.[a, b, c];
    quick_sort(ids, i=>i);
    return ids[0]*26*26*26*26 + ids[1]*26*26 + ids[2];
}

// Temporary while debugging
get_str :: (id: s64) -> string
{
    r : [2]u8;
    r[0] = cast(u8)(id / 26 + #char "a");
    r[1] = cast(u8)(id % 26 + #char "a");
    return tprint("%", cast(string)r);
}