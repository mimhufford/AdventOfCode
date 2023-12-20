day20 :: (input: string) -> string, string
{
    modules : [26*26]Module;

    for split(trim(input), "\n")
    {
        name := read_word(*it);
        read_word(*it);
        dsts := split(it, ", ");
        type : u8;
        if name[0] == #char "&" || name[0] == #char "%"
        {
            type = name[0];
            advance(*name);
        }
        index := name_to_index(name);
        modules[index].name = name;
        modules[index].type = type;
        for dsts
        {
            dst_index := name_to_index(it);
            array_add(*modules[index].dsts, dst_index);
            array_add(*modules[dst_index].srcs, index);
        }
    }

    head := 0;
    queue : [..]Pulse;

    for 1..1000
    {
        array_add(*queue, .{-1, 0, 0});

        while head < queue.count
        {
            p := queue[head];
            m := *modules[p.dst];
            head += 1;

            // print("[%] pulse % sent to % from %\n", head, p.state, m.name, p.src);

            if p.dst == 0
            {
                for m.dsts array_add(*queue, .{p.dst, it, p.state});
            }
            else if m.type == #char "%" && !p.state // flip-flop
            {
                m.state = 1 - m.state;
                for m.dsts array_add(*queue, .{p.dst, it, m.state});
            }
            else if m.type == #char "&" // conjuction
            {
                m.last[p.src] = p.state;
                to_send : s8;
                for m.srcs if m.last[it] == 0 { to_send = 1; break; }
                for m.dsts array_add(*queue, .{p.dst, it, to_send});
            }
        }
    }

    lo, hi := 0;
    for queue if it.state == 1 hi += 1; else lo += 1;
    part1, part2 := lo*hi;

    return tprint("%", part1), tprint("%", part2);
}

Pulse :: struct
{
    src: s16;
    dst: s16;
    state: s8;
}

Module :: struct
{
    name: string; // TODO: debug only, delete
    type: u8;
    dsts: [..]s16;
    srcs: [..]s16;   // for conjuction modules only
    last: [26*26]s8; // for conjuction modules only (TODO: wasteful, test a bitarray instead)
    state: s8;
}

name_to_index :: (n: string) -> s16
{
    if n.count == 2 return cast(s16)(n[0] - #char "a") * 26 + (n[1] - #char "a");
    return 0;
}