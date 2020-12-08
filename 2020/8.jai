day8 :: (program: string) -> string, string
{
    original_computer := create_computer(program);

    part1_computer := original_computer;
    run(*part1_computer);
    part1 := part1_computer.acc;

    part2 := 0;
    for i: 0..original_computer.ins_count
    {
        ins := original_computer.program[i];
        if ins.key != .NOP && ins.key != .JMP continue;
        if ins.key == .NOP && ins.value == 0  continue;
        part2_computer := original_computer;
        if ins.key == .NOP part2_computer.program[i].key = .JMP;
        else               part2_computer.program[i].key = .NOP;
        if run(*part2_computer) == .TERMINATED
        {
            part2 = part2_computer.acc;
            break;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Computer :: struct
{
    ip  : s16 = 0;
    acc : s64 = 0;
    ins_count := 0;
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

End_Reason :: enum u8
{
    TERMINATED;
    INFINITE_LOOP;
}

run :: (c: *Computer) -> End_Reason
{
    visited : [1000]u8;

    while true
    {
        if visited[c.ip] return .INFINITE_LOOP;
        visited[c.ip] = 1;
        still_running := tick(c);
        if !still_running return .TERMINATED;
    }

    assert(false);
    return .INFINITE_LOOP;
}

tick :: (c: *Computer) -> still_running: bool
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

    return c.ip != c.ins_count;
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

    computer.ins_count = i;
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