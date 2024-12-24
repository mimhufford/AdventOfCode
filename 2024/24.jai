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

    // NOTE: specific to my input
    swap_gate("hmt", "z18");
    swap_gate("bfq", "z27");
    swap_gate("hkh", "z31");
    swap_gate("fjp", "bng");

    // test all the 1-bit adders now work
    for vx: 0..44 for vy: 0..44
    {
        xv, yv := 1 << vx, 1 << vy;
        set_input(x, xv);
        set_input(y, yv);
        result := run_adder();
        assert(xv + yv == result);
    }

    part2 := "done"; // I don't want the long csv string in my output
    
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

swap_gate :: (a: string, b: string)
{
    g1 := find_or_add(*gates, a).*;
    g2 := find_or_add(*gates, b).*;
    g1.op, g2.op = g2.op, g1.op;
    g1.operand, g2.operand = g2.operand, g1.operand;
}

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

/*

This is where I manually organised my input to understand the circuit and then, by running the
circuit and adding single bits at a time, I could easily spot mistakes in certain 1-bit adders

x01 XOR y01 -> sgt
x01 AND y01 -> hqg
rjr XOR sgt -> z01
rjr AND sgt -> cff
hqg OR cff -> fkm

y02 XOR x02 -> hvb
x02 AND y02 -> rbm
fkm XOR hvb -> z02
fkm AND hvb -> hnv
hnv OR rbm -> bdp

y03 XOR x03 -> thv
y03 AND x03 -> bfs
bdp XOR thv -> z03
thv AND bdp -> rvq
bfs OR rvq -> cmh

x04 XOR y04 -> stt
x04 AND y04 -> pmq
stt XOR cmh -> z04
stt AND cmh -> mwj
mwj OR pmq -> ngj

y16 XOR x16 -> qpj
y16 AND x16 -> bpn
hdg XOR qpj -> z16
hdg AND qpj -> dhg
dhg OR bpn -> pch

y17 XOR x17 -> pbr
y17 AND x17 -> dpj
pbr XOR pch -> z17
pbr AND pch -> rrb
rrb OR dpj -> mdg

x18 XOR y18 -> jss
y18 AND x18 -> jcr
mdg XOR jss -> hmt     these two need swapping
jss AND mdg -> z18     these two need swapping
hmt OR jcr -> pfb

x19 XOR y19 -> jmh
x19 AND y19 -> wrc
pfb XOR jmh -> z19
jmh AND pfb -> nts
nts OR wrc -> scv

y26 XOR x26 -> fnf
y26 AND x26 -> jcb
cbj XOR fnf -> z26
cbj AND fnf -> pnj
jcb OR pnj -> gcc

x27 XOR y27 -> ntr
x27 AND y27 -> vgg
ntr XOR gcc -> bfq     these two need swapping
gcc AND ntr -> pph
vgg OR pph -> z27      these two need swapping

y30 XOR x30 -> qrt
y30 AND x30 -> nww
qrt XOR hhd -> z30
hhd AND qrt -> spj
nww OR spj -> ctc

x31 XOR y31 -> fqh
y31 AND x31 -> z31     these two need swapping
fqh XOR ctc -> hkh     these two need swapping
fqh AND ctc -> rjt
hkh OR rjt -> qhp

y37 XOR x37 -> ngq
x37 AND y37 -> kqm
ngq XOR cgm -> z37
ngq AND cgm -> vdw
kqm OR vdw -> vvr

y38 XOR x38 -> crj
y38 AND x38 -> cwb
crj XOR vvr -> z38
vvr AND crj -> mdm
mdm OR cwb -> hsf

x39 XOR y39 -> fjp     these two need swapping
y39 AND x39 -> bng     these two need swapping
hsf XOR bng -> z39
bng AND hsf -> tkf
tkf OR fjp -> vbm

x40 XOR y40 -> qqb
y40 AND x40 -> dnr
vbm XOR qqb -> z40
vbm AND qqb -> nhq
dnr OR nhq -> rgt

x14 AND y14 -> smm
y05 AND x05 -> rkt
y22 AND x22 -> gsg
x24 XOR y24 -> nkc
x08 XOR y08 -> prr
vbw AND qhp -> smg
hnt XOR wnj -> z13
dsb XOR rgt -> z41
tsw XOR vst -> z25
npr OR jnh -> fhw
stg AND trp -> fmk
ftt AND mcb -> wmd
kpt AND prr -> rdt
rqf XOR grt -> z33
hbq OR twj -> hkt
rkt OR ckj -> wts
kmk XOR qvw -> z09
jwd OR ssg -> cgm
jdb OR btb -> kpt
kvp AND pcv -> jnh
fff OR pgr -> tmk
hkt XOR qrn -> z34
btw OR gsg -> kvp
scv XOR mbp -> z20
y20 XOR x20 -> mbp
y00 XOR x00 -> z00
swn AND jkm -> tbg
kps OR wvq -> wgm
x43 AND y43 -> dcp
tfj XOR bcg -> z44
x06 XOR y06 -> vrh
y21 XOR x21 -> gbs
x44 AND y44 -> fnd
mkj OR rdt -> qvw
nvc XOR tgd -> z11
hkt AND qrn -> qdd
wts XOR vrh -> z06
ngj AND pqj -> ckj
x21 AND y21 -> pgr
y22 XOR x22 -> svq
y11 AND x11 -> tst
y15 XOR x15 -> nhg
rfw AND qnw -> wvq
fmk OR dbr -> wnj
y14 XOR x14 -> nmb
grt AND rqf -> hbq
tst OR jnn -> stg
y43 XOR x43 -> jtb
x10 AND y10 -> vrj
y36 XOR x36 -> rfv
wvn XOR trw -> z10
vrh AND wts -> mcs
x08 AND y08 -> mkj
y34 AND x34 -> gck
x35 XOR y35 -> qnw
wnj AND hnt -> qdw
y32 XOR x32 -> vbw
y25 XOR x25 -> tsw
x34 XOR y34 -> qrn
y05 XOR x05 -> pqj
ckp OR wbt -> hdg
vrj OR cvp -> nvc
x23 XOR y23 -> pcv
x13 XOR y13 -> hnt
y28 XOR x28 -> mkq
hrh OR vtn -> swn
stg XOR trp -> z12
nkc AND fhw -> ngb
ngj XOR pqj -> z05
x33 AND y33 -> twj
qdd OR gck -> rfw
swp XOR fcs -> z07
rfv AND wgm -> jwd
fnd OR scp -> z45
x13 AND y13 -> mkh
svq AND tmk -> btw
x32 AND y32 -> nwj
fhw XOR nkc -> z24
kpt XOR prr -> z08
swn XOR jkm -> z42
mkh OR qdw -> vsd
x36 AND y36 -> ssg
csh OR smm -> prp
y20 AND x20 -> jqj
y29 XOR x29 -> ftt
y24 AND x24 -> krb
vsd XOR nmb -> z14
x07 XOR y07 -> fcs
y10 XOR x10 -> wvn
nhg XOR prp -> z15
wgm XOR rfv -> z36
ngb OR krb -> vst
qvw AND kmk -> qfq
mcb XOR ftt -> z29
prp AND nhg -> ckp
y12 XOR x12 -> trp
y23 AND x23 -> npr
jtb XOR bkf -> z43
mbp AND scv -> tpm
mcs OR jwh -> swp
mkq XOR bfq -> z28
rfw XOR qnw -> z35
x11 XOR y11 -> tgd
y06 AND x06 -> jwh
tpm OR jqj -> pdc
qfq OR spq -> trw
x41 XOR y41 -> dsb
pdc XOR gbs -> z21
vst AND tsw -> jgn
y15 AND x15 -> wbt
kvp XOR pcv -> z23
x44 XOR y44 -> bcg
x42 AND y42 -> jfp
y07 AND x07 -> btb
tgd AND nvc -> jnn
nwj OR smg -> grt
fcs AND swp -> jdb
trw AND wvn -> cvp
dcp OR dmk -> tfj
y33 XOR x33 -> rqf
gbs AND pdc -> fff
svq XOR tmk -> z22
tfj AND bcg -> scp
y35 AND x35 -> kps
qfw OR pms -> mcb
y09 AND x09 -> spq
vsd AND nmb -> csh
tbg OR jfp -> bkf
rgt AND dsb -> vtn
jtb AND bkf -> dmk
y42 XOR x42 -> jkm
x28 AND y28 -> qfw
wmd OR bsk -> hhd
y09 XOR x09 -> kmk
qhp XOR vbw -> z32
hcp OR jgn -> cbj
y12 AND x12 -> dbr
y00 AND x00 -> rjr
y41 AND x41 -> hrh
y29 AND x29 -> bsk
y25 AND x25 -> hcp
bfq AND mkq -> pms

*/