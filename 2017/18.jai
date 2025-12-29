day18 :: (input: string) -> string, string
{
    Program :: struct {
        ip := 0;
        regs : Table(u8, s64); // change to [26]s64
        snd : [..]s64;
        rcv : *[..]s64;
        rcv_i := 0;
    }

    Instruction :: struct {
        type : enum { SND; SET; ADD; MUL; MOD; RCV; JGZ; };
        x_reg : u8;
        y_type : enum { REG; VAL; };
        y_reg : u8; // collapse to b: s64 when regs is an array
        y_val : s64;
    }

    instructions : [..]Instruction;

    while input {
        set_y :: () #expand {
            if input[0] >= "a" && input[0] <= "z" {
                i.y_type = .REG;
                i.y_reg = input[0];
                advance(*input, 2);
            } else {
                i.y_type = .VAL;
                i.y_val = read_s64(*input);
            }
        }
        i := array_add(*instructions);
        if read_word(*input) == {
            case "snd"; i.type = .SND; i.x_reg = input[0]; advance(*input, 2);
            case "rcv"; i.type = .RCV; i.x_reg = input[0]; advance(*input, 2);
            case "set"; i.type = .SET; i.x_reg = input[0]; advance(*input, 2); set_y();
            case "add"; i.type = .ADD; i.x_reg = input[0]; advance(*input, 2); set_y();
            case "mul"; i.type = .MUL; i.x_reg = input[0]; advance(*input, 2); set_y();
            case "mod"; i.type = .MOD; i.x_reg = input[0]; advance(*input, 2); set_y();
            case "jgz"; i.type = .JGZ; i.x_reg = input[0]; advance(*input, 2); set_y();
        }
    }

    a, b : Program;
    a.rcv = *b.snd;
    b.rcv = *a.snd;
    table_add(*a.regs, "1", 1);
    table_add(*b.regs, "1", 1);
    table_add(*a.regs, "p", 0);
    table_add(*b.regs, "p", 1);

    run :: (p: *Program) -> bool #expand {
        y :: (using i: Instruction) -> *s64 #expand {
            return ifx y_type == .VAL then *y_val else find_or_add(*p.regs, y_reg);
        }

        i := instructions[p.ip];
        x := find_or_add(*p.regs, i.x_reg);

        if i.type == {
            case .SET; x.*  = y(i).*;
            case .ADD; x.* += y(i).*;
            case .MUL; x.* *= y(i).*;
            case .MOD; x.* %= y(i).*;
            case .JGZ; if x.* > 0 p.ip += y(i).* - 1;
            case .SND; array_add(*p.snd, x.*);
            case .RCV;
            if p.rcv_i >= p.rcv.*.count return false;
            x.* = p.rcv.*[p.rcv_i];
            p.rcv_i += 1;
        }

        p.ip += 1;
        return true;
    }

    print_program :: (p: Program) {
        print("ip: %\n", p.ip);
        for p.regs {
            reg : [1]u8;
            reg[0] = it_index;
            print("r%: %\n", reg.(string), it);
        }
        print("rci: %\n", p.rcv_i);
        print("sni: %\n", p.snd);
        print("snc: %\n\n", p.snd.count);
    }

    while run(*a) || run(*b) {}

    part1 := a.snd[126];
    part2 := b.snd.count;

    return tprint("%", part1), tprint("%", part2);
}