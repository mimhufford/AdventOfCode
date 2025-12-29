day18 :: (input: string) -> string, string
{
    Program :: struct {
        ip := 0;
        regs : [26]s64;
        snd : [..]s64;
        rcv : *[..]s64;
        rcv_i := 0;
    }

    Instruction :: struct {
        type : enum { SND; SET; ADD; MUL; MOD; RCV; JGZ; };
        x_type, y_type : enum { REG; VAL; };
        x, y: s64;
    }

    instructions : [..]Instruction;

    while input {
        set_x :: () #expand {
            if input[0] >= "a" && input[0] <= "z" {
                i.x_type = .REG;
                i.x = input[0] - "a";
                advance(*input, 2);
            } else {
                i.x_type = .VAL;
                i.x = read_s64(*input);
            }
        }
        set_y :: () #expand {
            if input[0] >= "a" && input[0] <= "z" {
                i.y_type = .REG;
                i.y = input[0] - "a";
                advance(*input, 2);
            } else {
                i.y_type = .VAL;
                i.y = read_s64(*input);
            }
        }
        i := array_add(*instructions);
        if read_word(*input) == {
            case "snd"; i.type = .SND; set_x();
            case "rcv"; i.type = .RCV; set_x();
            case "set"; i.type = .SET; set_x(); set_y();
            case "add"; i.type = .ADD; set_x(); set_y();
            case "mul"; i.type = .MUL; set_x(); set_y();
            case "mod"; i.type = .MOD; set_x(); set_y();
            case "jgz"; i.type = .JGZ; set_x(); set_y();
        }
    }

    a, b : Program;
    a.rcv = *b.snd;
    b.rcv = *a.snd;
    a.regs[15] = 0;
    b.regs[15] = 1;

    run :: (p: *Program) -> bool #expand {
        x :: (using i: Instruction) -> *s64 #expand {
            return ifx x_type == .VAL then *x else *p.regs[x];
        }
        y :: (using i: Instruction) -> *s64 #expand {
            return ifx y_type == .VAL then *y else *p.regs[y];
        }

        i := instructions[p.ip];

        if i.type == {
            case .SET; x(i).*  = y(i).*;
            case .ADD; x(i).* += y(i).*;
            case .MUL; x(i).* *= y(i).*;
            case .MOD; x(i).* %= y(i).*;
            case .JGZ; if x(i).* > 0 p.ip += y(i).* - 1;
            case .SND; array_add(*p.snd, x(i).*);
            case .RCV;
            if p.rcv_i >= p.rcv.*.count return false;
            x(i).* = p.rcv.*[p.rcv_i];
            p.rcv_i += 1;
        }

        p.ip += 1;
        return true;
    }

    while run(*a) || run(*b) {}

    part1 := a.snd[126];
    part2 := b.snd.count;

    return tprint("%", part1), tprint("%", part2);
}