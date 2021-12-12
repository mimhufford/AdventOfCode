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
            a = table_add(*caves, a_name, cave);
        }
        if !b
        {
            cave : Cave;
            cave.name = b_name;
            b = table_add(*caves, b_name, cave);
        }
        array_add(*a.routes, b);
        array_add(*b.routes, a);
    }

    routes_1 := explore_routes_to_end(table_find_pointer(caves, "start"), true);
    routes_2 := explore_routes_to_end(table_find_pointer(caves, "start"), false);

	return tprint("%", routes_1), tprint("%", routes_2);
}

explore_routes_to_end :: (c: *Cave, twice: bool) -> u64
{
    impl :: (c: *Cave, visited: [..]*Cave, done_2: bool) -> u64
    {
        if c.name == "end" return 1;
        seen := array_find(visited, c);
        if seen && c.name == "start" return 0;
        if seen && done_2            return 0;
        now_done_2 := done_2 || seen;
        if c.name[0] >= #char "a" && c.name[0] <= #char "z" array_add(*visited, c);
        routes : u64;
        for c.routes routes += impl(it, visited, now_done_2);
        return routes;
    }

    visited : [..]*Cave;
    return impl(c, visited, twice);
}

Cave :: struct
{
    name   : string;
    routes : [..]*Cave;
}

read_pair :: (s: *string) -> string, string
{
    a : string = ---; a.data = s.data; a.count = 0;
    while s.count && s.data[0] != #char "-"
    {
        a.count += 1;
        advance(s, 1);
    }
    advance(s, 1);

    b : string = ---; b.data = s.data; b.count = 0;
    while s.count && s.data[0] != #char "\n"
    {
        b.count += 1;
        advance(s, 1);
    }
    advance(s, 1);

    return a, b;
}