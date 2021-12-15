day15 :: (data : string) -> string, string
{
    stride : s32;
    map : [..]s32;
    best : [..]s32;
    visited : [..]bool;
    best_x5 : [..]s32;
    visited_x5 : [..]bool;

    while data.count
    {
        if !stride && data[0] == #char "\n" stride = xx map.count;

        if data[0] >= #char "0" && data[0] <= #char "9"
        {
            array_add(*best, S32_MAX);
            array_add(*visited, false);
            for 1..25 array_add(*best_x5, S32_MAX);
            for 1..25 array_add(*visited_x5, false);
            array_add(*map, data[0] - #char "0");
        }

        advance(*data, 1);
    }

    best[0] = 0;
    best_x5[0] = 0;

    cost     :: (x: s32, y: s32) -> s32 #expand
    {
        dx := x / stride;
        dy := y / stride;
        val := map[(y%stride)*stride + (x%stride)];
        val += dx + dy;
        while val > 9 val -= 9;
        return val;
    }

    solve :: (size: s32, best: []s32, visited: []bool) -> s32 #expand
    {
        queue : [..]s32;
        array_add(*queue, 0);

        while queue.count
        {
            dist, i, qi : s32 = S32_MAX, 0, 0;
            for queue if best[it] < dist { dist = best[it]; i = it; qi = xx it_index; }
            if i == best.count-1 return best[i];
            array_unordered_remove_by_index(*queue, qi);
            if visited[i] continue;
            visited[i] = true;
            x, y := i % (stride*size), i / (stride*size);
            if x-1 >= 0          { ni := y*stride*size + (x-1); best[ni] = min(best[ni], best[i] + cost(x-1, y)); array_add(*queue, ni); }
            if x+1 < stride*size { ni := y*stride*size + (x+1); best[ni] = min(best[ni], best[i] + cost(x+1, y)); array_add(*queue, ni); }
            if y-1 >= 0          { ni := (y-1)*stride*size + x; best[ni] = min(best[ni], best[i] + cost(x, y-1)); array_add(*queue, ni); }
            if y+1 < stride*size { ni := (y+1)*stride*size + x; best[ni] = min(best[ni], best[i] + cost(x, y+1)); array_add(*queue, ni); }
        }
    }

    return tprint("%", solve(1, best, visited)), tprint("%", solve(5, best_x5, visited_x5));
}