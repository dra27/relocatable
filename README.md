# Relocatable OCaml

## It should Just Work™

Assembly, maintenance and testing scripts for the Relocatable Compiler patches.

The scripts here take the individual branches for relocatable and reassemble
them into a single patch-set. This patch-set is then back-ported to the latest
point update for 4.08 onwards. Some additional patches are back-ported partly
to ease rebasing and partly to allow CI to run in full for these updated
releases.

See [`Dockerfile`](Dockerfile) for approximate instructions on replicated the
process.
