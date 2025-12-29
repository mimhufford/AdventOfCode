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
        set :: (type: *type_of(Instruction.x_type), val: *s64) #expand {
            if input[0] >= "a" && input[0] <= "z" {
                type.* = .REG;
                val.* = input[0] - "a";
                advance(*input, 2);
            } else {
                type.* = .VAL;
                val.* = read_s64(*input);
            }
        }
        i := array_add(*instructions);
        if read_word(*input) == {
            case "snd"; i.type = .SND; set(*i.x_type, *i.x);
            case "rcv"; i.type = .RCV; set(*i.x_type, *i.x);
            case "set"; i.type = .SET; set(*i.x_type, *i.x); set(*i.y_type, *i.y);
            case "add"; i.type = .ADD; set(*i.x_type, *i.x); set(*i.y_type, *i.y);
            case "mul"; i.type = .MUL; set(*i.x_type, *i.x); set(*i.y_type, *i.y);
            case "mod"; i.type = .MOD; set(*i.x_type, *i.x); set(*i.y_type, *i.y);
            case "jgz"; i.type = .JGZ; set(*i.x_type, *i.x); set(*i.y_type, *i.y);
        }
    }

    a, b : Program;
    a.rcv = *b.snd;
    b.rcv = *a.snd;
    a.regs[15] = 0;
    b.regs[15] = 1;

    run :: (p: *Program) -> bool #expand {
        i := instructions[p.ip];
        x := ifx i.x_type == .VAL then *i.x else *p.regs[i.x];
        y := ifx i.y_type == .VAL then *i.y else *p.regs[i.y];

        if i.type == {
            case .SET; x.*  = y.*;
            case .ADD; x.* += y.*;
            case .MUL; x.* *= y.*;
            case .MOD; x.* %= y.*;
            case .JGZ; if x.* > 0 p.ip += y.* - 1;
            case .SND; array_add(*p.snd, x.*);
            case .RCV; if p.rcv_i >= p.rcv.*.count return false; x.* = p.rcv.*[p.rcv_i]; p.rcv_i += 1;
        }

        p.ip += 1;
        return true;
    }

    while run(*a) || run(*b) {}

    part1 := a.snd[126];
    part2 := b.snd.count;

    return tprint("%", part1), tprint("%", part2);
}