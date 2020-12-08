day7 :: (data: string) -> string, string
{
    bags : Table(string, *Bag);

    while data.count
    {
        id, contents := parse_line(*data);
        bag := find_or_make_bag(*bags, id);
        if contents[0] == #char "n" continue; // skip "no other bags"
        while true
        {
            ok, inner_count, inner_id := parse_bag(*contents);
            if !ok break;
            inner_bag := find_or_make_bag(*bags, inner_id);
            add_inner(bag, inner_count, inner_bag);
        }
    }

    part1 := -1; // to account for idenity bag
    for bags if does_bag_contain_other_bag(it, "shiny gold") part1 += 1;
    
    part2 := count_contents(find_or_make_bag(*bags, "shiny gold"));

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Bag :: struct
{
    id: string;
    contains_shiny_gold: bool;
    contents_count : s16 = -1;
    used_inner := 0;
    inner_count: [4]s16;
    inner_bags:  [4]*Bag;
}

add_inner :: (bag: *Bag, inner_count: s16, inner_bag: *Bag)
{
    bag.inner_count[bag.used_inner] = inner_count;
    bag.inner_bags [bag.used_inner] = inner_bag;
    bag.used_inner += 1;
}

does_bag_contain_other_bag :: (bag: *Bag, id: string) -> bool
{
    if bag.id == id || bag.contains_shiny_gold return true;
    for i: 0..bag.used_inner-1
    {
        it := bag.inner_bags[i];
        if it.contains_shiny_gold || does_bag_contain_other_bag(it, id)
        {
            bag.contains_shiny_gold = true;
            return true;
        }
    }
    return false;
}

count_contents :: (bag: *Bag) -> s16
{
    count : s16;
    for i: 0..bag.used_inner-1
    {
        b := bag.inner_bags[i];
        if b.contents_count != -1
        {
            count += bag.inner_count[i] + bag.inner_count[i] * b.contents_count;
        }
        else
        {
            count += bag.inner_count[i] + bag.inner_count[i] * count_contents(b);
        }
    }
    bag.contents_count = count;
    return count;
}

find_or_make_bag :: (bags: *Table(string, *Bag), id: string) -> *Bag
{
    found_bag := table_find_pointer(<<bags, id);
    if found_bag return <<found_bag;
    bag := New(Bag);
    bag.id = id;
    table_add(bags, id, bag);
    return bag;
}

read_number :: (s: *string) -> s16
{
    result : s16;

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        result *= 10;
        result += s.data[0] - #char "0";
        advance(s);
    } 

    advance(s);

    return result;
}

parse_line :: (s: *string) -> string, string
{
    id : string = ---;
    id.count = 0;
    id.data = s.data;

    while !(s.data[0] == #char " " && s.data[1] == #char "b" && s.data[2] == #char "a")
    {
        id.count += 1;
        advance(s);
    }

    advance(s, 14); // eat the contains bit

    contents : string = ---;
    contents.count = 0;
    contents.data = s.data;

    while s.count && s.data[0] != #char "."
    {
        advance(s, 1);
        contents.count += 1;
    } 

    advance(s, 1);            // eat the .
    if s.count advance(s, 1); // eat the \n

    return id, contents;
}

parse_bag :: (s: *string) -> bool, s16, string
{
    if !s.count return false, 0, "";

    count := read_number(s);

    id : string = ---;
    id.count = 0;
    id.data = s.data;

    while !(s.data[0] == #char " " && s.data[1] == #char "b" && s.data[2] == #char "a")
    {
        id.count += 1;
        advance(s);
    }

    advance(s, 4); // eat " bag"

    // eat any leftover junk
    if s.count && s.data[0] == #char "s" advance(s, 1);
    if s.count && s.data[0] == #char "," advance(s, 1);
    if s.count && s.data[0] == #char " " advance(s, 1);

    return true, count, id;
}