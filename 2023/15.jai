day15 :: (input: string) -> string, string
{
    part1, part2 := 0;
    map : [256][..]Item;

    for word: split(trim(input), ",")
    {
        full_hash, hash: u8;
        
        for 0..word.count-1
        {
            full_hash += word[it];
            full_hash *= 17;
            if word[it] == #char "=" continue;
            if word[it] == #char "-" continue;
            if is_digit(word[it])    continue;
            hash += word[it];
            hash *= 17;
        }
        
        if word[word.count-1] != #char "-"
        {
            key := word; key.count -= 2;
            index, item := find_item(map[hash], key);
            if item item.value = word[word.count-1] - #char "0";
            else array_add(*map[hash], .{key, hash, word[word.count-1] - #char "0"});
        }
        else
        {
            key := word; key.count -= 1;
            index := find_item(map[hash], key);
            if index >=0 array_ordered_remove_by_index(*map[hash], index);
        }

        part1 += full_hash;
    }

    for box, box_index: map for item, slot_index: box
    {
        part2 += (box_index+1) * (slot_index+1) * item.value;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

find_item :: (box: []Item, key: string) -> s64, *Item
{
    for * slot, slot_index: box
    {
        if slot.key == key
        {
            return slot_index, slot;
        }
    }

    return -1, null;
}

Item :: struct
{
    key   : string;
    hash  : u8;
    value : u8;
}