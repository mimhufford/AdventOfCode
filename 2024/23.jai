day23 :: (input: string) -> string, string
{
    while input
    {
        a := id(slice(input, 0, 2));
        b := id(slice(input, 3, 2));
        array_add_if_unique(*computer[a], b);
        array_add_if_unique(*computer[b], a);
        connection[a][b] = true;
        connection[b][a] = true;
        advance(*input, 6);
    }

    part1, part2 := find_t_triplets(), find_largest_bunch_of_nerds();

    // output the string length for part 2, the actual result looks bad in my output
    return tprint("%", part1), tprint("%", part2.count);
}

#scope_file

computer : [26*26] [..]s64;
connection : [26*26][26*26]bool;
largest_bunch_of_nerds : [..]s64;

find_t_triplets :: () -> s64
{
    triplets : [..]s64;

    for t: id("ta")..id("tz")
    {
        if !computer[t].count continue;

        for i: 0..computer[t].count-1
        {
            for j: i+1..computer[t].count-1
            {
                a, b := computer[t][i], computer[t][j];
                if !connection[a][t] continue;
                if !connection[a][b] continue;
                if !connection[b][t] continue;
                array_add_if_unique(*triplets, get_triplet_id(t, a, b));
            }
        }
    }

    return triplets.count;
}

find_largest_bunch_of_nerds :: () -> string
{
    bron_kerbosch :: (r: [..]s64, p: [..]s64, _x: [..]s64)
    {
        if !p.count && !_x.count
        {
            if r.count <= largest_bunch_of_nerds.count return;
            array_reset_keeping_memory(*largest_bunch_of_nerds);
            array_add(*largest_bunch_of_nerds, ..r);
            return;
        }

        x : [..]s64; array_add(*x, .._x);

        for v, i: p
        {
            np : [..]s64;
            for i..p.count-1 if connection[v][p[it]] array_add(*np, p[it]);
            nx := x;
            for nx if !connection[v][it] remove it;
            nr := r;
            array_add(*nr, v);
            bron_kerbosch(nr, np, nx);
            array_add(*x, v);
        }
    }

    r, p, x : [..]s64;
    array_reserve(*r, 128);
    for computer if it.count array_add(*p, it_index);
    bron_kerbosch(r, p, x);

    quick_sort(largest_bunch_of_nerds, i=>i);
    sb : String_Builder;
    for largest_bunch_of_nerds append(*sb, tprint("%,", get_str(it)));
    result := builder_to_string(*sb); result.count -= 1;
    return result;
}

id :: (c) => cast(s64)(c[0] - #char "a") * 26 + c[1] - #char "a";

get_triplet_id :: (a: s64, b: s64, c: s64) -> s64
{
    ids := s64.[a, b, c];
    quick_sort(ids, i=>i);
    return ids[0]*26*26*26*26 + ids[1]*26*26 + ids[2];
}

get_str :: (id: s64) -> string
{
    r : [2]u8;
    r[0] = cast(u8)(id / 26 + #char "a");
    r[1] = cast(u8)(id % 26 + #char "a");
    return tprint("%", cast(string)r);
}