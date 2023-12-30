day25 :: (input: string) -> string, string
{
    components   : [..]string;
    connections  : [..]Edge;
    index_lookup : Table(string, s64);

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

    part1 := min_cut(components.count, connections);
    
    return tprint("%", part1), "2023";
}

#scope_file

min_cut :: (components: s64, connections: [..]Edge) -> s64
{
    random_seed(cast(u64)to_microseconds(current_time_monotonic()));
    while true
    {
        nodes : [..]s64;  for 1..components array_add(*nodes, 1);
        edges : [..]Edge; for connections   array_add(*edges, it);
        count := components;

        while count > 2
        {
            edge_index := abs(cast(s64)random_get()) % edges.count;
            edge := edges[edge_index];
            
            count -= 1;
            array_add(*nodes, nodes[edge.a] + nodes[edge.b]);

            array_unordered_remove_by_index(*edges, edge_index);
            for * edges
            {
                if it.a == edge.a it.a = nodes.count-1;
                if it.a == edge.b it.a = nodes.count-1;
                if it.b == edge.a it.b = nodes.count-1;
                if it.b == edge.b it.b = nodes.count-1;
                if it.a == it.b remove it;
            }
        }

        count1 := nodes[edges[0].a];
        count2 := nodes[edges[0].b];

        if count1 > 100 && count2 > 100 return count1 * count2;
    }

    return 0;
}

find_or_add_component :: (name: string) -> s64 #expand
{
    cache := table_find_pointer(*`index_lookup, name);
    if cache return cache.*;
    array_add(*`components, name);
    table_add(*`index_lookup, name, `components.count - 1);
    return `components.count - 1;
}

Edge :: struct
{
    a, b : s64;
}