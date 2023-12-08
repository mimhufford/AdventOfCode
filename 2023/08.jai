day8 :: (input: string) -> string, string
{
    directions := read_word(*input);
    map : Table(string, Node);
    init(*map, 100000); // HACK: avoid reallocations

    while input.count
    {
        id := read_word(*input);
        advance(*input, 3);
        node := find_or_add(*map, id);
        l := read_word(*input); l.count -= 1;
        r := read_word(*input); r.count -= 1;
        node.id = id;
        node.l = find_or_add(*map, l);
        node.r = find_or_add(*map, r);
    }

    curr := find_or_add(*map, "AAA");
    part1 := 0;
    while true
    {
        if curr.id == "ZZZ" break;
        curr = ifx directions[part1 % directions.count] == #char "L" curr.l else curr.r;
        part1 += 1;
    }

    loops : [..]s64;
    for *map
    {
        if it_index[2] != #char "A" continue;
        
        curr := it;
        loop := array_add(*loops);

        while true
        {
            if curr.id[2] == #char "Z" break;
            curr = ifx directions[loop.* % directions.count] == #char "L" curr.l else curr.r;
            loop.* += 1;
        }
    }

    part2 := lcm(loops[0], loops[1]);
    for 2..loops.count-1
    {
        part2 = lcm(part2, loops[it]);
    }

    return tprint("%", part1), tprint("%", part2);
}

Node :: struct
{
    id : string;
    l, r : *Node;
    loop : s64;
}