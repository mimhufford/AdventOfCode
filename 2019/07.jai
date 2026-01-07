day7 :: (input: string) -> string, string
{
    Computer :: struct {
        ram  : []s64;
        in   : [..]s64;
        ip   : s64;
        out  : s64;
        done : bool;
    }

    reset :: (using c: *Computer) {
        in.count, ip, out, done = 0, 0, 0, false;
    }

    run :: (using c: *Computer) {
        while true {
            val :: (mode: s64, i: s64) -> s64 #expand {
                return ifx mode then ram[ip+i] else ram[ram[ip+i]];
            }
            op := ram[ip] % 100;
            m1 := ram[ip] / 100 % 10;
            m2 := ram[ip] / 1000 % 10;
            if op == {
                case 1; ram[ram[ip+3]] = val(m1, 1) + val(m2, 2); ip += 4;
                case 2; ram[ram[ip+3]] = val(m1, 1) * val(m2, 2); ip += 4;
                case 3; if in.count { ram[ram[ip+1]] = pop(*in); ip += 2; } else return;
                case 4; out = val(m1, 1); ip += 2; return;
                case 5; ip = ifx val(m1, 1) != 0 then val(m2, 2) else ip + 3;
                case 6; ip = ifx val(m1, 1) == 0 then val(m2, 2) else ip + 3;
                case 7; ram[ram[ip+3]] = ifx val(m1, 1)  < val(m2, 2) then 1; ip += 4;
                case 8; ram[ram[ip+3]] = ifx val(m1, 1) == val(m2, 2) then 1; ip += 4;
                case 99; done = true; return;
            }
        }
    }

    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));

    part1 := 0;
    settings : [..]s64; for 0..4 array_add(*settings, it);
    amp : [5]Computer;
    for * amp it.ram = array_copy(ram);
    for :permutations p: settings {
        for * amp reset(it);
        array_add(*amp[0].in, 0,          p[0]); run(*amp[0]);
        array_add(*amp[1].in, amp[0].out, p[1]); run(*amp[1]);
        array_add(*amp[2].in, amp[1].out, p[2]); run(*amp[2]);
        array_add(*amp[3].in, amp[2].out, p[3]); run(*amp[3]);
        array_add(*amp[4].in, amp[3].out, p[4]); run(*amp[4]);
        part1 = max(part1, amp[4].out);
    }

    part2 := 0;
    for * settings it.* += 5;
    for :permutations p: settings {
        for * a, id: amp { reset(a); array_add(*a.in, p[id]); run(a); }
        while !amp[4].done {
            array_add(*amp[0].in, amp[4].out); run(*amp[0]);
            array_add(*amp[1].in, amp[0].out); run(*amp[1]);
            array_add(*amp[2].in, amp[1].out); run(*amp[2]);
            array_add(*amp[3].in, amp[2].out); run(*amp[3]);
            array_add(*amp[4].in, amp[3].out); run(*amp[4]);
        }
        part2 = max(part2, amp[4].out);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

permutations :: (n: *[..]s64, body: Code, flags: For_Flags) #expand
{
    `it, `it_index, i, a := n.*, 0, 0, NewArray(n.count, s64);

    #insert body;
    it_index += 1;

    while i < n.count {
        if a[i] < i {
            swap(n.data + ifx i % 2 then a[i], n.data + i);
            #insert body;
            it_index += 1;
            a[i] += 1;
            i = 0;
        } else {
            a[i] = 0;
            i += 1;
        }
    }
}