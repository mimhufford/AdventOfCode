day11 :: (input: string) -> string, string
{
    head := New(Stone);
    head.value = read_s64(*input);
    
    last := head;
    while input
    {
        curr := New(Stone);
        curr.value = read_s64(*input);
        last.next = curr;
        last = curr;
    }

    for 1..25 blink(head);
    part1 :=  count(head);
    for 1..50 blink(head); // hello virtual memory
    part2 :=  count(head);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Stone :: struct
{
    value: s64;
    next: *Stone;
}

count :: (head: *Stone)
{
    count := 0;
    curr := head;
    while curr
    {
        count += 1;
        curr = curr.next;
    }
    return count;
}

blink :: (head: *Stone)
{
    curr := head;

    while curr
    {
        // Rule 1
        if curr.value == 0
        {
            curr.value = 1;
            curr = curr.next;
            continue;
        }

        // Rule 2
        did_split, a, b := attempt_split(curr.value);
        if did_split
        {
            curr.value = a;
            next := New(Stone);
            next.value = b;
            next.next = curr.next;
            curr.next = next;
            curr = next.next;
            continue;
        }

        // Rule 3
        curr.value *= 2024;
        curr = curr.next;
    }
}

log10 :: #run log(10.0);

attempt_split :: (n: s64) -> bool, s64, s64
{
    digits := cast(s64)(log(n*1.0) / log10) + 1;
    if digits % 2 return false, 0, 0;
    splitter := cast(s64)pow(10.0, digits*0.5);
    return true, n / splitter, n % splitter;
}