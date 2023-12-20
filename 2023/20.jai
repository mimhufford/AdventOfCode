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

    lo, hi := 0;
    rx := name_to_index("rx");         assert(modules[rx].srcs.count == 1);
    rx_input := modules[rx].srcs[0];   assert(modules[rx_input].srcs.count == 4);
    cycles : [26*26]s64;
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

            if p.state == 0
            {
                for modules[rx_input].srcs if p.dst == it && cycles[it] == 0 cycles[it] = presses;
                all_set := true;
                for modules[rx_input].srcs if cycles[it] == 0 { all_set = false; break; }
                if all_set break presses;
            }
        }
    }

    part1 := lo*hi;
    part2 := 1;
    for modules[rx_input].srcs part2 = lcm(part2, cycles[it]);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

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
    last: [26*26]s8; // for conjuction modules only
    state: s8;
}

name_to_index :: (n: string) -> s16
{
    if n.count == 2 return cast(s16)(n[0] - #char "a") * 26 + (n[1] - #char "a");
    return 0;
}