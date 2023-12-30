day25 :: (input: string) -> string, string
{
    components   : [..]Component;
    index_lookup : Table(string, s64);

    for split(trim(input), "\n")
    {
        name  := read_up_to(*it, #char ":");
        start := find_or_add_component(name);

        for split(advance(it, 2), " ")
        {
            end := find_or_add_component(it);
            array_add(*components[start].conns, end);
            array_add(*components[end].conns, start);
        }
    }

    for 1..500
    {
        lo, hi := 1.0, -1.0;
        for * c: components
        {
            for c.conns c.scratch += components[it].value;
            c.scratch /= c.conns.count;
            lo = min(lo, c.scratch);
            hi = max(hi, c.scratch);
        }

        for * c: components
        {
            c.value = -1.0 + (c.scratch - lo) * (2.0) / (hi - lo);
        }
    }

    a,b := 0;
    for components if it.value < 0 a += 1; else b += 1;
    part1 := a * b;
    
    return tprint("%", part1), "2023";
}

#scope_file

find_or_add_component :: (name: string) -> s64 #expand
{
    index := table_find_pointer(*`index_lookup, name);
    if index return index.*;
    table_add(*`index_lookup, name, `index_lookup.count);
    c := array_add(*`components);
    c.name = name;
    c.value = random_get_within_range(-1, 1);
    return `index_lookup.count - 1;
}

Component :: struct
{
    name : string;
    value : float;
    scratch : float;
    conns : [..]s64;
}