day20 :: (input: string) -> string, string
{
    part1 := process(input,  1, 1);
    part2 := process(input, 10, 811589153);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Node :: struct
{
    value : s64;
    prev  : *Node;
    next  : *Node;
}

process :: (input: string, times: s64, multiplier: s64) -> s64
{
    ring : [..]*Node;
    zero : *Node;

    for s64s(input)
    {
        node := New(Node);
        node.value = it;
        if it == 0 zero = node;
        array_add(*ring,  node);
    }

    for 0..ring.count-1
    {
        ring[it].prev = ring[(it+ring.count-1) % ring.count];
        ring[it].next = ring[(it+1) % ring.count];
    }

    for 1..times
    {
        for ring
        {
            if it.value == 0 continue;

            it.next.prev = it.prev;
            it.prev.next = it.next;

            t := it;
            steps := (it.value * multiplier) % (ring.count - 1);
            if it.value > 0 for i: 1..steps t = t.next;
            if it.value < 0 for i: steps..0 t = t.prev;

            t.next.prev = it;
            it.next     = t.next;
            t.next      = it;
            it.prev     = t;
        }
    }

    result := 0;

    for 1..3000
    {
        zero = zero.next;
        if it % 1000 == 0 result += zero.value * multiplier;
    }

    return result;
}