day8 :: (input: string) -> string, string
{
    part1, part2 := 0;
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

    for *map
    {
        if it_index[2] != #char "A" continue;
        
        curr := it;
        loop := 0;

        while true
        {
            if curr.id[2] == #char "Z" break;
            curr = ifx directions[loop % directions.count] == #char "L" curr.l else curr.r;
            loop += 1;
        }

        if it_index == "AAA" part1 = loop;
        part2 = ifx part2 == 0 loop else lcm(part2, loop);
    }

    return tprint("%", part1), tprint("%", part2);
}

Node :: struct
{
    id : string;
    l, r : *Node;
    loop : s64;
}