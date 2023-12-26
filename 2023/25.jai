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
            array_add(*components[start].connections, end);
            array_add(*components[end].connections, start);
        }
    }

    part1, part2 := 0, 0;
    
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

find_or_add_component :: (name: string) -> s64 #expand
{
    cache := table_find_pointer(*`index_lookup, name);
    if cache return cache.*;
    c := array_add(*`components);
    c.name = name;
    table_add(*`index_lookup, name, `components.count - 1);
    return `components.count - 1;
}

Component :: struct
{
    name : string;
    connections : [..]s64;
}