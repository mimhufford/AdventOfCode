day18 :: (input: string) -> string, string
{
    part1, part2 := 0;

    program := parse_program(input);
    regs : Table(u8, s64);
    ip := 0;

    while true {
        value :: (using i: Instruction) -> s64 #expand {
            return ifx b_type == .VAL then b_val else find_or_add(*regs, b_reg).*;
        }

        using i := program[ip];
        a := find_or_add(*regs, a_reg);

        if type == {
            case .SND; part1 = a.*;
            case .SET; a.*  = value(i);
            case .ADD; a.* += value(i);
            case .MUL; a.* *= value(i);
            case .MOD; a.* %= value(i);
            case .RCV; if a.* != 0 break;
            case .JGZ; if a.* > 0 ip += value(i) - 1;
        }

        ip += 1;
    }

    ip_a, ip_b := 0;
    regs_a, regs_b : Table(u8, s64);
    queue_a, queue_b : [..]s64;
    table_add(*regs_a, "p", 0);
    table_add(*regs_b, "p", 1);

    pump :: (ip: *s64, regs: *Table(u8, s64), snd: *[..]s64, rcv: *[..]s64) -> bool #expand {
        value :: (using i: Instruction) -> s64 #expand {
            return ifx b_type == .VAL then b_val else find_or_add(regs, b_reg).*;
        }

        using i := program[ip.*];
        a := find_or_add(regs, a_reg);

        if type == {
            case .SET; a.*  = value(i);
            case .ADD; a.* += value(i);
            case .MUL; a.* *= value(i);
            case .MOD; a.* %= value(i);
            case .JGZ; if a.* > 0 ip.* += value(i) - 1;
            case .SND; array_insert_at(snd, a.*, 0); find_or_add(regs, " ").* += 1;
            case .RCV; if rcv.*.count == 0 return true; else a.* = pop(rcv);
        }

        ip.* += 1;
        return false;
    }

    while true {
        a_waiting := pump(*ip_a, *regs_a, *queue_b, *queue_a);
        b_waiting := pump(*ip_b, *regs_b, *queue_a, *queue_b);
        print("% % - % % - % %\n", a_waiting, b_waiting, find_or_add(*regs_a, " ").*, find_or_add(*regs_b, " ").*, queue_a.count, queue_b.count);
        if a_waiting && b_waiting break;
    };

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Instruction :: struct {
    type : enum { SND; SET; ADD; MUL; MOD; RCV; JGZ; };
    a_reg : u8;
    b_type : enum { REG; VAL; };
    b_reg : u8;
    b_val : s64;
}

parse_program :: (input: string) -> []Instruction {
    program : [..]Instruction;

    while input {
        set_b :: () #expand {
            if input[0] >= "a" && input[0] <= "z" {
                i.b_type = .REG;
                i.b_reg = input[0];
                advance(*input, 2);
            } else {
                i.b_type = .VAL;
                i.b_val = read_s64(*input);
            }
        }
        i := array_add(*program);
        if read_word(*input) == {
            case "snd"; i.type = .SND; i.a_reg = input[0]; advance(*input, 2);
            case "rcv"; i.type = .RCV; i.a_reg = input[0]; advance(*input, 2);
            case "set"; i.type = .SET; i.a_reg = input[0]; advance(*input, 2); set_b();
            case "add"; i.type = .ADD; i.a_reg = input[0]; advance(*input, 2); set_b();
            case "mul"; i.type = .MUL; i.a_reg = input[0]; advance(*input, 2); set_b();
            case "mod"; i.type = .MOD; i.a_reg = input[0]; advance(*input, 2); set_b();
            case "jgz"; i.type = .JGZ; i.a_reg = input[0]; advance(*input, 2); set_b();
        }
    }

    return program;
}