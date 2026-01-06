day7 :: (input: string) -> string, string
{
    run :: (ram: []s64, in: []s64) -> s64 {
        ip, out := 0;

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
                case 3; ram[ram[ip+1]] = pop(*in); ip += 2;
                case 4; out = val(m1, 1); ip += 2;
                case 5; ip = ifx val(m1, 1) != 0 then val(m2, 2) else ip + 3;
                case 6; ip = ifx val(m1, 1) == 0 then val(m2, 2) else ip + 3;
                case 7; ram[ram[ip+3]] = ifx val(m1, 1)  < val(m2, 2) then 1; ip += 4;
                case 8; ram[ram[ip+3]] = ifx val(m1, 1) == val(m2, 2) then 1; ip += 4;
                case 99; break;
            }
        }

        return out;
    }

    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));

    part1 := 0;
    settings : [..]s64; for 0..4 array_add(*settings, it);
    for :permutations settings {
        a := run(array_copy(ram), s64.[0, it[0]]);
        b := run(array_copy(ram), s64.[a, it[1]]);
        c := run(array_copy(ram), s64.[b, it[2]]);
        d := run(array_copy(ram), s64.[c, it[3]]);
        e := run(array_copy(ram), s64.[d, it[4]]);
        part1 = max(part1, e);
    }

    part2 := 0;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

permutations :: (n: *[..]s64, body: Code, flags: For_Flags) #expand
{
    `it, `it_index := n.*, 0;

    #insert body;
    `it_index += 1;

    arr := NewArray(n.count, s64);

    j := 0;
    while j < n.count {
        if arr[j] < j {
            swap(n.data + ifx j % 2 then arr[j], n.data + j);

            #insert body;
            `it_index += 1;

            arr[j] += 1;
            j = 0;
        } else {
            arr[j] = 0;
            j += 1;
        }
    }
}