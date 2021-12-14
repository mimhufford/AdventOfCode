day11 :: (data: string) -> string, string
{
    password := data;
    password.count -= 1;

    while true { increment(password); if valid(password) break; }
    part_1 := tprint("%", password);
    while true { increment(password); if valid(password) break; }
    part_2 := password;

    return tprint("%", part_1), tprint("%", part_2);
}

valid :: (p: string) -> bool {
    straight := false;
    pair_1 : u8;
    pair_2 : u8;

    for i: 0..p.count-1 {
        if i < p.count-3 && p[i]+2 == p[i+1]+1 && p[i]+2 == p[i+2]     straight = true;
        if p[i] == #char "i" || p[i] == #char "o" || p[i] == #char "l"    return false;
        if !pair_1 && i < p.count-1 && p[i] == p[i+1]                    pair_1 = p[i];
        if  pair_1 && i < p.count-1 && p[i] == p[i+1] && p[i] != pair_1  pair_2 = p[i];
    }

    return straight && pair_1 > 0 && pair_2 > 0;
}

increment :: (password: string, index : u8 = 7) {
    password[index] += 1;
    if password[index] > #char "z" {
        password[index] = #char "a";
        increment(password, index - 1);
    }
}