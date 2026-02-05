day17 :: (data: string) -> string, string
{
    containers : [..]s64;
    litres :: 150;

    while data.count array_add(*containers, get(s64, *data));

    combinations := 0;
    counts : [100]s64;

    for combination: 1..(1<<containers.count)-1
    {
        sum := 0;
        containers_used := 0;
        for i: 0..containers.count-1
        {
            if combination & (1<<i)
            {
                sum += containers[i];
                containers_used += 1;
            }
            if sum > litres break;
        }
        if sum == litres
        {
            combinations += 1;
            counts[containers_used] += 1;
        }
    }

    amount_of_minimum_containers_used := 0;
    for counts if it > 0 { amount_of_minimum_containers_used = it; break; }

    return tprint("%", combinations), tprint("%", amount_of_minimum_containers_used);
}