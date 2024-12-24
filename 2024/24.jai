day24 :: (input: string) -> string, string
{
    while input
    {
        gate := New(Gate);
        gate.id = input; gate.id.count = 3; advance(*input, 5);
        gate.state = input[0] - #char "0";  advance(*input, 2);
        gate.done = true;
        if gate.id[0] == #char "x" x[read_s64(*advance(gate.id))] = gate;
        if gate.id[0] == #char "y" y[read_s64(*advance(gate.id))] = gate;
        table_add(*gates, gate.id, gate);
        if input[0] != #char "\n" continue;
        advance(*input);
        break;
    }

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
        if gate.*.id[0] == #char "z" z[read_s64(*advance(gate.*.id))] = gate.*;

        array_add(*circuit, gate.*);
    }

    part1 := run_adder();

    for vx: 0..44 for vy: 0..44
    {
        xv := 1 << vx;
        yv := 1 << vy;
        set_input(x, xv);
        set_input(y, yv);
        result := run_adder();
        if xv + yv != result
        {
            print("% + % != %\n", xv, yv, result);
            break vx;
        }
    }

    part2 := 0;
    
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

gates : Table(string, *Gate);
x : [45]*Gate;
y : [45]*Gate;
z : [46]*Gate;
circuit : [..]*Gate;

Gate :: struct
{
    id : string;
    state : u8;
    done : bool;
    op : Operator;
    operand : [2]*Gate;
}

Operator :: enum u8 { NONE; XOR; OR; AND; };

set_input :: (input: [45]*Gate, v: s64)
{
    for 0..44
    {
        gate := input[it];
        gate.state = xx ifx v & (1 << it) then 1 else 0;
    }
}

run_adder :: () -> s64
{
    todo : [..]*Gate;
    for circuit it.done = false;
    array_add(*todo, ..circuit);
    while todo for g: todo if resolve(g) remove g;

    result := 0;
    for z if it.state result |= 1 << it_index;
    return result;
}

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