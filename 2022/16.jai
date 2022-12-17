day16 :: (input: string) -> string, string
{
    valves, dist := parse_valves(input);

    max_flow = 0;

    walk(valves[0], 30, dist);

    walk :: (v: *Valve, time: s64, dist: [16][16]s64, prev_visits: u16 = 0, prev_flow: s64 = 0)
    {
        flow := prev_flow + v.flow * max(time, 0);

        if time < 1
        {
            max_flow = max(flow, max_flow);
            return;
        }

        visited := prev_visits | cast(u16)1 << v.index;

        for v.cons
        {
            if visited & cast(u16)1 << it.index continue;

            steps := dist[v.index][it.index];
            walk(it, time - steps - 1, dist, visited, flow);
        }
    }

    return tprint("%", max_flow), tprint("%", "");
}

max_flow := 0;

#scope_file

Valve :: struct
{
    index : s64;
    name  : string;
    flow  : s64;
    cons  : [..]*Valve;
}

parse_valves :: (s: string) -> []*Valve, [16][16]s64
{
    add_or_find :: (name: string, valves: *[..]*Valve) -> *Valve
    {
        for <<valves if it.name == name return it;
        valve := New(Valve);
        valve.name = name;
        array_add(valves, valve);
        return valve;
    }

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
            array_add(*valve.cons, other);
            advance(*s, 2);
            if s[0] == #char "," advance(*s, 2);
        }

        skip_whitespace(*s);
    }

    // sort so AA is first, and valves with flow are next
    quick_sort(valves, v => cast(s64)v.name[0]*26 + v.name[1] - ifx v.name == "AA" || v.flow > 0 then 100000 else 0);

    // now assign indexes so we can quickly lookup distances
    for valves it.index = it_index;

    // generate the full distance matrix
    size := valves.count;
    dist := NewArray(size * size, s64);
    for *dist { <<it = S64_MAX; }
    for 0..size-1 dist[it*size + it] = 0;
    for v, i1: valves
    {
        for c: v.cons
        {
            i2 := 0; for valves if it == c { i2 = it_index; break; }
            dist[i1*size + i2] = 1;
        }
    }

    // floyd-warshal method to find shortest path between all valve pairs
    for k: 0..size-1 for i: 0..size-1 for j: 0..size-1
    {
        if dist[i*size+k] == S64_MAX continue;
        if dist[k*size+j] == S64_MAX continue;

        if dist[i*size+j] > dist[i*size+k] + dist[k*size+j]
            dist[i*size+j] = dist[i*size+k] + dist[k*size+j];
    }

    // re-write the neighbour graph for interesting valves
    for valves it.cons.count = 0;
    for 1..15 array_add(*valves[0].cons, valves[it]);
    for a: 1..15 for b: 1..15 if a != b array_add(*valves[a].cons, valves[b]);

    // only return the interesting valves
    valves.count = 16;

    // only return the interesting valve distances
    dists : [16][16]s64;
    for x: 0..15 for y: 0..15 dists[x][y] = dist[x*size + y];

    return valves, dists;
}