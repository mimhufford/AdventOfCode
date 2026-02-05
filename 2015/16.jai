day16 :: (data: string) -> string, string
{
    sues : [..]Sue;

    sender : Sue;
    sender.cars = 2;
    sender.cats = 7;
    sender.trees = 3;
    sender.akitas = 0;
    sender.vizslas = 0;
    sender.perfumes = 1;
    sender.samoyeds = 2;
    sender.children = 3;
    sender.goldfish = 5;
    sender.pomeranians = 3;

    while data.count array_add(*sues, read_sue(*data));

    part_1 := 0;

    for sues
    {
        if it.cars        != -1 && it.cars        != sender.cars          continue;
        if it.cats        != -1 && it.cats        != sender.cats          continue;
        if it.trees       != -1 && it.trees       != sender.trees         continue;
        if it.akitas      != -1 && it.akitas      != sender.akitas        continue;
        if it.vizslas     != -1 && it.vizslas     != sender.vizslas       continue;
        if it.perfumes    != -1 && it.perfumes    != sender.perfumes      continue;
        if it.samoyeds    != -1 && it.samoyeds    != sender.samoyeds      continue;
        if it.children    != -1 && it.children    != sender.children      continue;
        if it.goldfish    != -1 && it.goldfish    != sender.goldfish      continue;
        if it.pomeranians != -1 && it.pomeranians != sender.pomeranians   continue;

        part_1 = it_index + 1;
        break;
    }

    part_2 := 0;

    for sues
    {
        if it.cars        != -1 && it.cars        != sender.cars          continue;
        if it.cats        != -1 && it.cats        <= sender.cats          continue;
        if it.trees       != -1 && it.trees       <= sender.trees         continue;
        if it.akitas      != -1 && it.akitas      != sender.akitas        continue;
        if it.vizslas     != -1 && it.vizslas     != sender.vizslas       continue;
        if it.perfumes    != -1 && it.perfumes    != sender.perfumes      continue;
        if it.samoyeds    != -1 && it.samoyeds    != sender.samoyeds      continue;
        if it.children    != -1 && it.children    != sender.children      continue;
        if it.goldfish    != -1 && it.goldfish    >= sender.goldfish      continue;
        if it.pomeranians != -1 && it.pomeranians >= sender.pomeranians   continue;

        part_2 = it_index + 1;
        break;
    }

    return tprint("%", part_1), tprint("%", part_2);
}

Sue :: struct
{   
    cars: s8 = -1;
    cats: s8 = -1;
    trees: s8 = -1;
    akitas: s8 = -1;
    vizslas: s8 = -1;
    children: s8 = -1;
    goldfish: s8 = -1;
    perfumes: s8 = -1;
    samoyeds: s8 = -1;
    pomeranians: s8 = -1;
}

read_sue :: (s: *string) -> Sue
{
    read_stat :: () #expand
    {
        if s.data[0] ==
        {
            case #char "a";                { advance(s, 8);  sue.akitas      = read_num(); }
            case #char "g";                { advance(s, 10); sue.goldfish    = read_num(); }
            case #char "s";                { advance(s, 10); sue.samoyeds    = read_num(); }
            case #char "t";                { advance(s, 7);  sue.trees       = read_num(); }
            case #char "v";                { advance(s, 9);  sue.vizslas     = read_num(); }
            case #char "c";
            if      s.data[2] == #char "r" { advance(s, 6);  sue.cars        = read_num(); }
            else if s.data[2] == #char "t" { advance(s, 6);  sue.cats        = read_num(); }
            else                           { advance(s, 10); sue.children    = read_num(); }
            case #char "p";
            if s.data[1] == #char "e"      { advance(s, 10); sue.perfumes    = read_num(); }
            else                           { advance(s, 13); sue.pomeranians = read_num(); }
        }
    }

    read_num :: () -> s8 #expand
    {
        num : s8;
        while s.data[0] >= #char "0" && s.data[0] <= #char "9"
        {
            num *= 10;
            num += xx (s.data[0] - #char "0");
            advance(s, 1);
        }
        return num;
    }

    sue : Sue;

    while s.data[0] != #char ":" advance(s, 1);
    advance(s, 2);

    read_stat();
    advance(s, 2);
    read_stat();
    advance(s, 2);
    read_stat();
    advance(s, 1);

    return sue;
}