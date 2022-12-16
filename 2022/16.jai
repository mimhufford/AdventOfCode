day16 :: (input: string) -> string, string
{
    valves, dist := parse_valves(input);

    // parsing is optimised enough
    // need to work on the valve walk order next

    max_flow := 0;

    // TODO: this does give the correct answer but takes too long
    for permutations(valves)
    {
        time := 30;
        pos  : s64;
        next := 0;
        flow := 0;

        if it_index % 100000000 == 0 print("%\n", max_flow);

        while true
        {
            valve := it[next];
            next  += 1;
            time  -= dist[pos][valve.index] + 1;
            flow  += valve.flow * max(time, 0);
            pos    = valve.index;
            if time < 1 break;
            if next >= valves.count break;
        }

        max_flow = max(max_flow, flow);
    }

    return tprint("%", max_flow), tprint("%", "");
}

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

    // only return the interesting valves
    valves.count = 15;
    valves.data += 1;

    // only return the interesting valve distances
    dists : [16][16]s64;
    for x: 0..15 for y: 0..15 dists[x][y] = dist[x*size + y];

    return valves, dists;
}



for_expansion :: (pi: *PermutationsIterator, body: Code, flags: For_Flags) #expand
{
    `it_index := 0;
    `it       := pi.a;

    #insert body;
    `it_index += 1;

    c := NewArray(pi.a.count, int);
    i := 1;

    while i < pi.a.count
    {
        if c[i] < i
        {
            if i % 2 == 0 Swap(*pi.a[0], *pi.a[i]);
            else          Swap(*pi.a[c[i]], *pi.a[i]);

            #insert body;
            c[i] += 1;
            i = 1;
            `it_index += 1;
        }
        else
        {
            c[i] = 0;
            i += 1;
        }
    }

    free(c.data);
}

permutations :: (a: []$T) -> PermutationsIterator(T)
{
   i : PermutationsIterator(T) = ---;
   i.a = a;
   return i;
}

PermutationsIterator :: struct ($T: Type)
{
    a: []T;
}