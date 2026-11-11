function rename_number_dash
    for file in *
        # Create new name
        set new_name (string replace -r '^([0-9]+) - ' '$1. ' -- $file)

        # Rename only if different
        if test "$file" != "$new_name"
            mv -- "$file" "$new_name"
        end
    end
end

function rename_number_space
    for file in *
        # Create new name
        set new_name (string replace -r '^([0-9]+) ' '$1. ' -- $file)

        # Rename only if different
        if test "$file" != "$new_name"
            mv -- "$file" "$new_name"
        end
    end
end

function splitcue --description "Split and tag a FLAC album using a CUE sheet"
    if test (count $argv) -ne 2
        echo "Usage: splitcue <album.flac> <album.cue>" >&2
        return 1
    end

    if not test -f "$argv[1]"; or not test -f "$argv[2]"
        echo "Audio file or CUE sheet not found" >&2
        return 1
    end

    set -lx ALBUM (realpath -- "$argv[1]")
    set -lx CUE (realpath -- "$argv[2]")

    nix-shell -p cuetools shntool flac ffmpeg --run '
        set -e
        shopt -s nullglob

        tmp=$(mktemp -d -p "$PWD" .splitcue-XXXXXXXX)
        trap '\''rm -rf -- "$tmp"'\'' EXIT

        shnsplit -f "$CUE" \
            -d "$tmp" \
            -o flac \
            -t "%n. %t" \
            "$ALBUM"

        tracks=()
        for f in "$tmp"/[0-9][0-9].\ *.flac; do
            [[ ${f##*/} == 00.* ]] || tracks+=("$f")
        done

        if (( ${#tracks[@]} == 0 )); then
            echo "No tracks generated" >&2
            exit 1
        fi

        cuetag "$CUE" "${tracks[@]}"

        for f in "$tmp"/*.flac; do
            if [[ -e "./${f##*/}" ]]; then
                echo "Output already exists: ${f##*/}" >&2
                exit 1
            fi
        done

        mv -- "$tmp"/*.flac .
        echo "Successfully split ${#tracks[@]} tracks"
    '
end
