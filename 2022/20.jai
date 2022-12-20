day20 :: (input: string) -> string, string
{
    ring : [..]*Node;
    zero : *Node;

    for s16s(input)
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

    for ring
    {
        if it.value == 0 continue;

        it.next.prev = it.prev;
        it.prev.next = it.next;

        t := it;
        if it.value > 0 for i: 1..it.value t = t.next;
        if it.value < 0 for i: it.value..0 t = t.prev;

        t.next.prev = it;
        it.next     = t.next;
        t.next      = it;
        it.prev     = t;
    }

    part1 := 0;
    n := zero;
    for 1..3000
    {
        n = n.next;
        if it % 1000 == 0 part1 += n.value;
    }

    return tprint("%", part1), tprint("%", "");
}

#scope_file

Node :: struct
{
    value : s16;
    prev  : *Node;
    next  : *Node;
}