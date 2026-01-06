day7 :: (input: string) -> string, string
{
    Computer :: struct {
        ram : []s64;
        in  : [..]s64;
        ip  : s64;
        out : s64;
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
                case 3; ram[ram[ip+1]] = pop(*in); ip += 2;
                case 4; out = val(m1, 1); ip += 2;
                case 5; ip = ifx val(m1, 1) != 0 then val(m2, 2) else ip + 3;
                case 6; ip = ifx val(m1, 1) == 0 then val(m2, 2) else ip + 3;
                case 7; ram[ram[ip+3]] = ifx val(m1, 1)  < val(m2, 2) then 1; ip += 4;
                case 8; ram[ram[ip+3]] = ifx val(m1, 1) == val(m2, 2) then 1; ip += 4;
                case 99; break;
            }
        }
    }

    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));

    part1 := 0;
    settings : [..]s64; for 0..4 array_add(*settings, it);
    for :permutations settings {
        a := Computer.{ram = array_copy(ram)}; array_add(*a.in, 0,     it[0]); run(*a);
        b := Computer.{ram = array_copy(ram)}; array_add(*b.in, a.out, it[1]); run(*b);
        c := Computer.{ram = array_copy(ram)}; array_add(*c.in, b.out, it[2]); run(*c);
        d := Computer.{ram = array_copy(ram)}; array_add(*d.in, c.out, it[3]); run(*d);
        e := Computer.{ram = array_copy(ram)}; array_add(*e.in, d.out, it[4]); run(*e);
        part1 = max(part1, e.out);
    }

    part2 := 0;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

permutations :: (n: *[..]s64, body: Code, flags: For_Flags) #expand
{
    `it, `it_index, j := n.*, 0, 0;
    arr := NewArray(n.count, s64);

    #insert body;
    `it_index += 1;

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