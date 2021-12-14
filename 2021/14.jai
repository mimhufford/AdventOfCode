day14 :: (data : string) -> string, string
{
    pairs : Table(string, s64);
    rules : Table(string, [2]string);
    counts : [26]s64;

    counts[data[0] - #char "A"] = 1; // count first char

    while data[1] != #char "\n"
    {
        pair : string = ---;
        pair.data = data.data;
        pair.count = 2;
        table_add(*pairs, pair, 1);
        advance(*data, 1);
    }

    advance(*data, 3);

    while data.count
    {
        src : string = ---;
        src.data = data.data;
        src.count = 2;
        advance(*data, 6);
        dst : [2]string;
        dst0 : [2]u8; dst0[0] = src[0]; dst0[1] = data[0];
        dst1 : [2]u8; dst1[1] = src[1]; dst1[0] = data[0];
        dst[0] = tprint("%", cast(string)dst0);
        dst[1] = tprint("%", cast(string)dst1);
        table_add(*rules, src, dst);
        if !table_find_pointer(pairs, src   ) table_add(*pairs, src   , 0);
        if !table_find_pointer(pairs, dst[0]) table_add(*pairs, dst[0], 0);
        if !table_find_pointer(pairs, dst[1]) table_add(*pairs, dst[1], 0);
        advance(*data, 2);
    }

    for 1..10 grow(pairs, rules);
    for count, pair : pairs counts[pair[1] - #char "A"] += count;
    part_1 := diff(counts);
    for count, pair : pairs counts[pair[1] - #char "A"] -= count;
    for 1..30 grow(pairs, rules);
    for count, pair : pairs counts[pair[1] - #char "A"] += count;
    part_2 := diff(counts);

    return tprint("%", part_1), tprint("%", part_2);
}

grow :: (pairs : Table, rules : Table)
{
    copy : Table(string, s64);
    for pairs table_add(*copy, it_index, it);

    for count, pair : copy
    {
        if !count continue;

        r := table_find_pointer(rules, pair);
        <<table_find_pointer(pairs, pair) -= count;
        <<table_find_pointer(pairs, (<<r)[0]) += count;
        <<table_find_pointer(pairs, (<<r)[1]) += count;
    }
}

diff :: inline (counts : []s64) -> s64
{
    most, least := S64_MIN, S64_MAX;

    for counts
    {
        if it < least && it  least = it;
        if it > most          most = it;
    }

    return most - least;
}