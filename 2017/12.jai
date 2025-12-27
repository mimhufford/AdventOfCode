day12 :: (input: string) -> string, string
{
    part1, part2 := 0;

    nodes : [2000][..]s64;
    
    while input {
        id := read_s64(*input);
        advance(*input, 4);
        while true {
            other := read_s64(*input);
            array_add_if_unique(*nodes[id], other);
            array_add_if_unique(*nodes[other], id);
            if !input || input[0] != "," break;
            advance(*input, 2);
        }
    }

    seen_ids : [..]s64;
    seen_group, queue : [..]s64;

    for id: 0..nodes.count-1 {
        if array_find(seen_ids, id) continue;

        array_reset_keeping_memory(*seen_group);
        array_add(*queue, id);

        while queue {
            n := pop(*queue);
            if array_find(seen_group, n) continue;
            array_add(*seen_ids, n);
            array_add(*seen_group, n);
            for nodes[n] array_add(*queue, it);
        }

        part1 = ifx id == 0 then seen_group.count else part1;
        part2 += 1;
    }

    return tprint("%", part1), tprint("%", part2);
}