day12 :: (data : string) -> string, string
{
    caves : Table(string, Cave);

    while data.count
    {
        a_name, b_name := read_pair(*data);
        a := table_find_pointer(caves, a_name);
        b := table_find_pointer(caves, b_name);
        if !a
        {
            cave : Cave;
            cave.name = a_name;
            cave.small = a_name[0] >= #char "a" && a_name[0] <= #char "z";
            a = table_add(*caves, a_name, cave);
        }
        if !b
        {
            cave : Cave;
            cave.name = b_name;
            cave.small = b_name[0] >= #char "a" && b_name[0] <= #char "z";
            b = table_add(*caves, b_name, cave);
        }
        array_add(*a.routes, b);
        array_add(*b.routes, a);
    }

    routes_1 := explore_routes_to_end_1(table_find_pointer(caves, "start"));
    routes_2 := explore_routes_to_end_2(table_find_pointer(caves, "start"));

	return tprint("%", routes_1), tprint("%", routes_2);
}

explore_routes_to_end_1 :: (c: *Cave) -> u64
{
    impl :: (c: *Cave, visited: [..]*Cave) -> u64
    {
        if c.name == "end"        return 1;
        if array_find(visited, c) return 0;

        if c.small array_add(*visited, c);

        routes : u64;
        for c.routes routes += impl(it, visited);
        return routes;
    }

    visited : [..]*Cave;
    return impl(c, visited);
}

explore_routes_to_end_2 :: (c: *Cave) -> u64
{
    impl :: (c: *Cave, visited: [..]*Cave, done_2 := false) -> u64
    {
        if c.name == "end"                             return 1;
        if c.name == "start" && array_find(visited, c) return 0;
        if done_2 && array_find(visited, c)            return 0;

        now_done_2 := done_2 || array_find(visited, c);

        if c.small array_add(*visited, c);

        routes : u64;
        for c.routes routes += impl(it, visited, now_done_2);
        return routes;
    }

    visited : [..]*Cave;
    return impl(c, visited);
}

Cave :: struct
{
    name   : string;
    small  : bool;
    routes : [..]*Cave;
}

read_pair :: (s: *string) -> string, string
{
    a : string = ---;
    b : string = ---;

    a.data = s.data; a.count = 0;
    while s.count && s.data[0] != #char "-"
    {
        a.count += 1;
        advance(s, 1);
    }

    advance(s, 1);

    b.data = s.data; b.count = 0;
    while s.count && s.data[0] != #char "\n"
    {
        b.count += 1;
        advance(s, 1);
    }

    advance(s, 1);

    return a, b;
}