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
        if directions[part1 % directions.count] == #char "L"
        {
            curr = curr.l;
        }
        else
        {
            curr = curr.r;
        }
        part1 += 1;
    }

    return tprint("%", part1), tprint("%", 0);
}

Node :: struct
{
    id : string;
    l, r : *Node;
}