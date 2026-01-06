day5 :: (input: string) -> string, string
{
    run :: (ram: []s64, in: s64) -> s64 {
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
                case 3; ram[ram[ip+1]] = in; ip += 2;
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

    part1 := run(array_copy(ram), 1);
    part2 := run(array_copy(ram), 5);

    return tprint("%", part1), tprint("%", part2);
}