day15 :: (data : string) -> string, string
{
    stride : s64;
    map : [..]s64;
    best : [..]s64;
    visited : [..]bool;
    best_x5 : [..]s64;
    visited_x5 : [..]bool;

    while data.count
    {
        if !stride && data[0] == #char "\n" stride = xx map.count;

        if data[0] >= #char "0" && data[0] <= #char "9"
        {
            array_add(*best, S64_MAX);
            array_add(*visited, false);
            for 1..25 array_add(*best_x5, S64_MAX);
            for 1..25 array_add(*visited_x5, false);
            array_add(*map, data[0] - #char "0");
        }

        advance(*data, 1);
    }

    best[0] = 0;
    best_x5[0] = 0;

    index    :: (x: s64, y: s64) -> s64 #expand { return y*stride + x; }
    xy       :: (i: s64) -> s64, s64 #expand { return i % stride, i / stride; }
    xy_x5    :: (i: s64) -> s64, s64 #expand { return i % (stride*5), i / (stride*5); }
    index_x5 :: (x: s64, y: s64) -> s64 #expand { return y*stride*5 + x; }
    map_x5   :: (x: s64, y: s64) -> s64 #expand
    {
        dx := x / stride;
        dy := y / stride;
        val := map[(y%stride)*stride + (x%stride)];
        val += dx + dy;
        while val > 9 val -= 9;
        return val;
    }

    {
        queue : [..]s64;
        array_add(*queue, 0);

        while queue.count
        {
            dist, i, qi := S64_MAX, 0, 0;
            for queue if best[it] < dist { dist = best[it]; i = it; qi = it_index; }
            if i == best.count-1 break;
            array_unordered_remove_by_index(*queue, qi);
            if visited[i] continue;
            visited[i] = true;
            x, y := xy(i);
            if x-1 >= 0     { ni := index(x-1, y); best[ni] = min(best[ni], best[i] + map[ni]); array_add(*queue, ni); }
            if x+1 < stride { ni := index(x+1, y); best[ni] = min(best[ni], best[i] + map[ni]); array_add(*queue, ni); }
            if y-1 >= 0     { ni := index(x, y-1); best[ni] = min(best[ni], best[i] + map[ni]); array_add(*queue, ni); }
            if y+1 < stride { ni := index(x, y+1); best[ni] = min(best[ni], best[i] + map[ni]); array_add(*queue, ni); }
        }
    }

    {
        queue : [..]s64;
        array_add(*queue, 0);

        while queue.count
        {
            dist, i, qi := S64_MAX, 0, 0;
            for queue {
                if best_x5[it] < dist { dist = best_x5[it]; i = it; qi = it_index; }
            }
            if i == best_x5.count-1 break;
            array_unordered_remove_by_index(*queue, qi);
            if visited_x5[i] continue;
            visited_x5[i] = true;
            x, y := xy_x5(i);
            if x-1 >= 0       { ni := index_x5(x-1, y); best_x5[ni] = min(best_x5[ni], best_x5[i] + map_x5(x-1, y)); array_add(*queue, ni); }
            if x+1 < stride*5 { ni := index_x5(x+1, y); best_x5[ni] = min(best_x5[ni], best_x5[i] + map_x5(x+1, y)); array_add(*queue, ni); }
            if y-1 >= 0       { ni := index_x5(x, y-1); best_x5[ni] = min(best_x5[ni], best_x5[i] + map_x5(x, y-1)); array_add(*queue, ni); }
            if y+1 < stride*5 { ni := index_x5(x, y+1); best_x5[ni] = min(best_x5[ni], best_x5[i] + map_x5(x, y+1)); array_add(*queue, ni); }
        }
    }

    return tprint("%", best[index(stride-1, stride-1)]), tprint("%", best_x5[index_x5(stride*5-1, stride*5-1)]);
}