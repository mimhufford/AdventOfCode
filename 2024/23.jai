day23 :: (input: string) -> string, string
{
    connections : [26*26] [..]s64;

    while input
    {
        a := input; a.count = 2; advance(*input, 3);
        b := input; b.count = 2; advance(*input, 3);

        ai, bi := get_id(a), get_id(b);
        
        array_add_if_unique(*connections[ai], bi);
        array_add_if_unique(*connections[bi], ai);
    }

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

    part1, part2 := triplets.count, 0;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

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