day7 :: (input: string) -> string, string
{
    Node :: struct {
        id: string;
        weight: s64;
        total_weight: s64;
        parent: *Node;
        children: [..]*Node;
        children_ids: []string;
    }

    nodes : Table(string, Node);

    while input {
        id := read_word(*input);    advance(*input);
        weight := read_s64(*input); advance(*input);

        node := find_or_add(*nodes, id);
        node.id = id;
        node.weight = weight;
        node.total_weight = weight;

        if input[0] == "\n" { advance(*input); continue; }

        advance(*input, 4);
        node.children_ids = split(read_up_to(*input, "\n"), ", ");
        advance(*input);
    }

    for * n: nodes {
        for id: n.children_ids {
            child := table_find_pointer(*nodes, id);
            array_add(*n.children, child);
            child.parent = n;
        }
    }

    root : *Node;
    for * nodes if it.parent == null { root = it; break; }
    part1 := root.id;

    calculate_weight :: (n: *Node) -> s64 {
        for n.children n.total_weight += calculate_weight(it);
        return n.total_weight;
    }

    calculate_weight(root);

    find_odd :: (n: *Node) -> s64 {
        inner :: (n: *Node, result: *s64) {
            if n.children.count == 0 return;

            weight := n.children[0].total_weight;
            all_same := true;
            for n.children {
                all_same &= it.total_weight == weight;
                inner(it, result);
            }

            if !all_same && !result.* {
                hi, lo := 0, S64_MAX;
                weight := 0;

                for n.children {
                    if it.total_weight > hi { hi = it.total_weight; weight = it.weight; }
                    if it.total_weight < lo { lo = it.total_weight; }
                }

                result.* = weight + lo - hi;
            }
        }
        result := 0;
        inner(n, *result);
        return result;
    }

    part2 := find_odd(root);

    return part1, tprint("%", part2);
}