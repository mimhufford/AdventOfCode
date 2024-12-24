day24 :: (input: string) -> string, string
{
    while input
    {
        gate := New(Gate);
        gate.id = input; gate.id.count = 3; advance(*input, 5);
        gate.state = input[0] - #char "0";  advance(*input, 2);
        gate.done = true;
        table_add(*gates, gate.id, gate);
        if input[0] != #char "\n" continue;
        advance(*input);
        break;
    }

    todo : [..]*Gate;

    while input
    {
        op1 := read_word(*input);
        op  := read_word(*input);
        op2 := read_word(*input);
        _   := read_word(*input);
        gid := read_word(*input);
    
        op1g, new1 := find_or_add(*gates, op1);
        if new1 op1g.* = New(Gate);
        op1g.*.id = op1;

        op2g, new2 := find_or_add(*gates, op2);
        if new2 op2g.* = New(Gate);
        op2g.*.id = op2;

        gate, new3 := find_or_add(*gates, gid);
        if new3 gate.* = New(Gate);
        gate.*.id = gid;
        gate.*.op = str_to_op(op);
        gate.*.operand[0] = op1g.*;
        gate.*.operand[1] = op2g.*;

        array_add(*todo, gate.*);
    }

    while todo for g: todo if resolve(g) remove g;

    part1, part2 := 0;
    
    for 0..63
    {
        gate := table_find_pointer(*gates, tprint("z%", formatInt(it, minimum_digits=2)));
        if !gate break;
        part1 |= gate.*.state;
        part1 <<= 1;
    }

    return tprint("%", part1), tprint("%", part2);
}

// 7781788678266 too low

#scope_file

gates : Table(string, *Gate);

Gate :: struct
{
    id : string;
    state : u8;
    done : bool;
    op : Operator;
    operand : [2]*Gate;
}

Operator :: enum u8 { NONE; XOR; OR; AND; };

resolve :: (using g: *Gate) -> bool
{
    if !operand[0].done return false;
    if !operand[1].done return false;
    
    if      op == .OR  state = operand[0].state | operand[1].state;
    else if op == .XOR state = operand[0].state ^ operand[1].state;
    else if op == .AND state = operand[0].state & operand[1].state;
    
    done = true;
    return true;
}

str_to_op :: (s: string) -> Operator
{
    if s == "OR"  return .OR;
    if s == "XOR" return .XOR;
    if s == "AND" return .AND;
    assert(false);
    return .NONE;
}