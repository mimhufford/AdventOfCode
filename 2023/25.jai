day25 :: (input: string) -> string, string
{
    components  : Table(string, s64);
    connections : [..]Edge;

    for split(trim(input), "\n")
    {
        name  := read_up_to(*it, #char ":");
        start := find_or_add_component(name);

        for split(advance(it, 2), " ")
        {
            end := find_or_add_component(it);
            array_add(*connections, .{start, end});
        }
    }

    Comp :: struct
    {
        name : string;
        value : float;
        scratch : float;
        conns : [..]s64;
    }
    test := NewArray(components.count, Comp);
    for components
    {
        test[it].name = it_index;
        test[it].value = random_get_within_range(-1, 1);
    }
    for connections
    {
        array_add(*test[it.a].conns, it.b);
        array_add(*test[it.b].conns, it.a);
    }

    for 1..500
    {
        lo, hi := 1.0, -1.0;
        for * c: test
        {
            for c.conns c.scratch += test[it].value;
            c.scratch /= c.conns.count;
            lo = min(lo, c.scratch);
            hi = max(hi, c.scratch);
        }

        for * c: test
        {
            c.value = -1.0 + (c.scratch - lo) * (2.0) / (hi - lo);
        }
    }

    a,b := 0;
    for test if it.value < 0 a += 1; else b += 1;
    part1 := a * b;
    
    return tprint("%", part1), "2023";
}

#scope_file

find_or_add_component :: (name: string) -> s64 #expand
{
    index := table_find_pointer(*`components, name);
    if index return index.*;
    table_add(*`components, name, `components.count);
    return `components.count - 1;
}

Edge :: struct
{
    a, b : s64;
}