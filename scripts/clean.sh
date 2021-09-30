source scripts/shared.sh

for f in $FILES; do
    target="${HOME}/${f}"
    if test -f "$target"; then
        rm -v "$target"
    fi
done
