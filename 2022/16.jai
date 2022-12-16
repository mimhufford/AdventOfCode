day16 :: (input: string) -> string, string
{
    valves := parse_valves(input);

    max_flow := 0;

    // TODO: this does give the correct answer but takes too long
    for permutations(valves)
    {
        time := 30;
        pos  : u16;
        next := 0;
        flow := 0;

        while true
        {
            valve := it[next];
            next  += 1;
            time  -= dist[pos][valve.name] + 1;
            flow  += valve.flow * max(time, 0);
            pos    = valve.name;
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
    name : u16;
    flow : u8;
}

// TODO: this is way bigger than it needs to be, generate this after parsing and compressing the space down
SIZE :: 26*26;
dist : [SIZE][SIZE]u8;

pack :: s => cast(u16)(s[0] - #char "A") * 26 + s[1] - #char "A";

parse_valves :: (s: string) -> []Valve
{
    for i: 0..SIZE-1 for j: 0..SIZE-1 dist[i][j] = U8_MAX;
    for 0..SIZE-1 dist[it][it] = 0;

    valves : [..]Valve;

    while s
    {
        v : Valve;
        read_word(*s);
        v.name = pack(read_word(*s));
        for 1..2 read_word(*s);
        advance(*s, 5);
        v.flow = read_u8(*s);
        for 1..5 read_word(*s);

        if v.flow array_add(*valves, v);

        while s[0] != #char "\n"
        {
            dist[v.name][pack(s)] = 1;
            advance(*s, 2);
            if s[0] == #char "," advance(*s, 2);
        }

        skip_whitespace(*s);
    }

    for k: 0..SIZE-1 for i: 0..SIZE-1 for j: 0..SIZE-1
    {
        if dist[i][k] == U8_MAX continue;
        if dist[k][j] == U8_MAX continue;

        if dist[i][j] > dist[i][k] + dist[k][j]
            dist[i][j] = dist[i][k] + dist[k][j];
    }

    return valves;
}

// Generic array permutation generator

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
