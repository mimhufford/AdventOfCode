Computer :: struct {
    ram  : []s64;
    in   : Queue(s64);
    ip   : s64;
    rb   : s64;
    out  : Queue(s64);
    done : bool;
    size : s64;
}

computer :: (ram: []s64) -> *Computer {
    c := New(Computer);
    c.ram = ram;
    c.size = ram.count + 3000;
    reset(c);
    return c;
}

reset :: (using c: *Computer) {
    ip, rb, done = 0, 0, false;
    reset_keeping_memory(*in);
    reset_keeping_memory(*out);
    array_resize(*ram, size);
}

run :: (using c: *Computer, inputs : ..s64) {
    for inputs push_back(*in, it);
    while ram[ip] != 99 {
        m1, m2, m3 := ram[ip]/100 % 10, ram[ip]/1000 % 10, ram[ip]/10000 % 10;
        a := ifx m1 == 0 then ram[ip + 1] else ifx m1 == 1 then ip + 1 else rb + ram[ip + 1];
        b := ifx m2 == 0 then ram[ip + 2] else ifx m2 == 1 then ip + 2 else rb + ram[ip + 2];
        c := ifx m3 == 0 then ram[ip + 3] else ifx m3 == 1 then ip + 3 else rb + ram[ip + 3];
        if ram[ip] % 100 == {
            case 1; ram[c] = ram[a] + ram[b]; ip += 4;
            case 2; ram[c] = ram[a] * ram[b]; ip += 4;
            case 3; if (in.count == 0) return; ram[a] = pop_front(*in); ip += 2;
            case 4; push_back(*out, ram[a]); ip += 2;
            case 5; ip = ifx ram[a] != 0 then ram[b] else ip + 3;
            case 6; ip = ifx ram[a] == 0 then ram[b] else ip + 3;
            case 7; ram[c] = ifx ram[a]  < ram[b] then 1; ip += 4;
            case 8; ram[c] = ifx ram[a] == ram[b] then 1; ip += 4;
            case 9; rb += ram[a]; ip += 2;
        }
    }
    done = true;
}