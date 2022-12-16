day16 :: (input: string) -> string, string
{
    valves := parse_valves(input);

    // for valves print("[%] %\n", it, <<it);

    return tprint("%", ""), tprint("%", "");
}

#scope_file

Connection :: struct
{
    other : *Valve;
    steps : s64;
}

Valve :: struct
{
    name : string;
    flow : s16;
    cons : [..]Connection;
}

add_or_find :: (name: string, valves: *[..]*Valve) -> *Valve
{
    for <<valves if it.name == name return it;
    valve := New(Valve);
    valve.name = name;
    array_add(valves, valve);
    return valve;
}

parse_valves :: (s: string) -> []*Valve
{
    valves : [..]*Valve;

    while s
    {
        read_word(*s);
        valve := add_or_find(read_word(*s), *valves);
        for 1..2 read_word(*s);
        advance(*s, 5);
        valve.flow = read_u8(*s);
        for 1..5 read_word(*s);

        while s[0] != #char "\n"
        {
            name := s;
            name.count = 2;
            other := add_or_find(name, *valves);
            array_add(*valve.cons, .{other, 1});
            advance(*s, 2);
            if s[0] == #char "," advance(*s, 2);
        }

        skip_whitespace(*s);
    }

    for v: valves
    {
        if v.name != "AA" && v.flow == 0
        {
            for c: v.cons
            {
                // delete us from other
                for * cv: c.other.cons
                {
                    if cv.other == v
                    {
                        remove cv;
                        break;
                    }
                }

                // add anythign that isn't itself to others
                for cc: v.cons
                {
                    if c.other == cc.other continue;
                    array_add(*c.other.cons, .{cc.other, cc.steps + 1});
                }
            }

            remove v;
        }
    }

    return valves;
}