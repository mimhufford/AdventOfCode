day17 :: (data: string) -> string, string
{
    containers : [..]s64;
    litres :: 150;

    while data.count array_add(*containers, next_s64(*data));

    combinations := 0;

    for combination: 1..(1<<containers.count)-1
    {
        sum := 0;
        for i: 0..containers.count-1
        {
            if combination & (1<<i) sum += containers[i];
            if sum > litres break;
        }
        if sum == litres combinations += 1;
    }

    return tprint("%", combinations), tprint("%", "");
}