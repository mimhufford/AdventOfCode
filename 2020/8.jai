day8 :: (program: string) -> string, string
{
    computer := create_computer(program);

    visited : [1000]u8;
    part1 := 0;
    while true
    {
        if visited[computer.ip]
        {
            part1 = computer.acc;
            break;
        }
        visited[computer.ip] = 1;
        tick(*computer);
    }

    return tprint("%", part1), "";
}

#scope_file

Computer :: struct
{
    ip  : s16 = 0;
    acc : s64 = 0;
    program : [1000]Instruction;
}

Instruction :: struct
{
    key   : Key;
    value : s64 = 1;
}

Key :: enum u8
{
    NOP;
    ACC;
    JMP;
}

tick :: (c: *Computer)
{
    i := c.program[c.ip];
    if i.key == .ACC
    {
        c.acc += i.value;
        c.ip  += 1;
    }
    else if i.key ==.NOP
    {
        c.ip += 1;
    }
    else
    {
        c.ip += xx i.value;
    }
}

create_computer :: (program: string) -> Computer
{
    computer : Computer;

    i := 0;
    while program.count
    {
        computer.program[i] = parse_instruction(*program);
        i += 1;
    }

    return computer;
}

parse_instruction :: (s: *string) -> Instruction
{
    result : Instruction = .{.NOP, 0};
    if      s.data[0] == #char "a" result.key = .ACC;
    else if s.data[0] == #char "j" result.key = .JMP;

    advance(s, 4);
    neg := s.data[0] == #char "-";
    advance(s, 1);
    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        result.value *= 10;
        result.value += s.data[0] - #char "0";
        advance(s, 1);
    }
    if neg result.value *= -1;
    if s.count advance(s, 1);

    return result;
}