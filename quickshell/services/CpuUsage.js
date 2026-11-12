.pragma library

// /proc/stat counters are cumulative. Compare samples rather than showing
// the since-boot average. Each cpuN is a logical CPU (an SMT thread).
function parse(text) {
    const sample = {};
    const lines = text.trim().split(/\n/);
    for (const line of lines) {
        const fields = line.trim().split(/\s+/);
        if (!/^cpu\d*$/.test(fields[0]) || fields.length < 5)
            continue;

        const counters = [];
        let valid = true;
        // guest and guest_nice are already included in user and nice.
        for (let i = 1; i <= 8; i++) {
            const value = i < fields.length ? Number(fields[i]) : 0;
            if (!isFinite(value) || value < 0)
                valid = false;
            counters.push(value);
        }
        if (valid)
            sample[fields[0]] = counters;
    }
    return sample;
}

function usage(previous, current) {
    if (!previous || !current)
        return null;

    let total = 0;
    let busy = 0;
    for (let i = 0; i < 8; i++) {
        const delta = current[i] - previous[i];
        // iowait can decrease; other backwards counters need a new baseline.
        if (delta < 0 && i !== 4)
            return null;
        const elapsed = Math.max(0, delta);
        total += elapsed;
        if (i !== 3 && i !== 4)
            busy += elapsed;
    }
    return total > 0 ? Math.min(100, Math.max(0, busy / total * 100)) : null;
}

function measure(previous, current) {
    let peak = 0;
    const cores = [];
    for (const name in current) {
        if (name === "cpu")
            continue;
        const value = usage(previous[name], current[name]);
        cores.push({ id: Number(name.slice(3)), usage: value });
        if (value !== null)
            peak = Math.max(peak, value);
    }
    cores.sort(function(a, b) { return a.id - b.id; });
    return { all: usage(previous.cpu, current.cpu), peak: peak, cores: cores };
}
