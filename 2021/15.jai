day15 :: (data : string) -> string, string
{
    stride : s32;
    map : [..]s32;

    while data.count
    {
        if !stride && data[0] == #char "\n" stride = xx map.count;

        if data[0] >= #char "0" && data[0] <= #char "9"
            array_add(*map, data[0] - #char "0");

        advance(*data, 1);
    }

    cost :: (x: s32, y: s32) -> s32 #expand
    {
        dx := x / stride;
        dy := y / stride;
        val := map[(y%stride)*stride + (x%stride)];
        val += dx + dy;
        while val > 9 val -= 9;
        return val;
    }

    solve :: (size: s32) -> s32 #expand
    {
        best : [..]s32;
        visited : [..]bool;
        array_resize(*best, stride*size*stride*size);
        array_resize(*visited, stride*size*stride*size);
        for * best { <<it = S32_MAX; }
        best[0] = 0;
        queue : [..]s32;
        array_add(*queue, 0);

        add_priority :: (index: s32) #expand
        {
            l, r := 0, queue.count-1;

            if (queue.count)
            {
                p := best[index];
                while l < r
                {
                    m := (l+r) / 2;
                    mp := best[queue[m]];
                    if      mp < p  r = m-1;
                    else if mp > p  l = m+1;
                    else    { l = m; r = m; }
                }
            }

            array_insert_at(*queue, index, l);
        }

        while queue.count
        {
            i := pop(*queue);
            if i == best.count-1 return best[i];
            if visited[i] continue;
            visited[i] = true;
            x, y := i % (stride*size), i / (stride*size);
            if x-1 >= 0          { ni := y*stride*size + (x-1); best[ni] = min(best[ni], best[i] + cost(x-1, y)); add_priority(ni); }
            if x+1 < stride*size { ni := y*stride*size + (x+1); best[ni] = min(best[ni], best[i] + cost(x+1, y)); add_priority(ni); }
            if y-1 >= 0          { ni := (y-1)*stride*size + x; best[ni] = min(best[ni], best[i] + cost(x, y-1)); add_priority(ni); }
            if y+1 < stride*size { ni := (y+1)*stride*size + x; best[ni] = min(best[ni], best[i] + cost(x, y+1)); add_priority(ni); }
        }
    }

    return tprint("%", solve(1)), tprint("%", solve(5));
}