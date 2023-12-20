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
        modules[index].type = type;
        for dsts
        {
            dst_index := name_to_index(it);
            array_add(*modules[index].dsts, dst_index);
            array_add(*modules[dst_index].srcs, index);
        }
    }

    // TODO: hardcoded, instead get inputs to input of rx
    mr := name_to_index("mr");
    kv := name_to_index("kv");
    rz := name_to_index("rz");
    jg := name_to_index("jg");
    mrc, kvc, rzc, jgc := 0;

    lo, hi := 0;

    queue : [..]Pulse;

    for presses: 1..S64_MAX
    {
        array_reset_keeping_memory(*queue);
        head := 0;
        array_add(*queue, .{-1, 0, 0});

        while head < queue.count
        {
            p := queue[head];
            m := *modules[p.dst];
            head += 1;

            if presses <= 1000
            {
                lo += 1 - p.state;
                hi += p.state;
            }

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

            if p.dst == mr && p.state == 0 && mrc == 0 mrc = presses;
            if p.dst == kv && p.state == 0 && kvc == 0 kvc = presses;
            if p.dst == rz && p.state == 0 && rzc == 0 rzc = presses;
            if p.dst == jg && p.state == 0 && jgc == 0 jgc = presses;
            if mrc && kvc && rzc && jgc break presses;
        }
    }

    part1 := lo*hi;
    part2 := lcm(lcm(lcm(mrc, kvc), rzc), jgc);

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