day8 :: (input: string) -> string, string
{
    part1, part2 := 1;
    directions := read_word(*input);
    map : Table(string, Node);

    while input.count
    {
        id      := read_word(*input); advance(*input, 3);
        node    := find_or_add(*map, id);
        node.lid = read_word(*input); node.lid.count -= 1;
        node.rid = read_word(*input); node.rid.count -= 1;
        node.id  = id;
    }

    for * node: map
    {
        node.l = table_find_pointer(*map, node.lid);
        node.r = table_find_pointer(*map, node.rid);
    }

    for * curr, id: map
    {
        if id[2] != #char "A" continue;
        
        loop := 0;

        while curr.id[2] != #char "Z"
        {
            curr = ifx directions[loop % directions.count] == #char "L" curr.l else curr.r;
            loop += 1;
        }

        part1 = ifx id == "AAA" loop else part1;
        part2 = lcm(part2, loop);
    }

    return tprint("%", part1), tprint("%", part2);
}

Node :: struct
{
    id, lid, rid : string;
    l, r : *Node;
}