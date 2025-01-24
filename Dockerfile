FROM ocaml/opam:ubuntu-22.04-opam AS base

RUN sudo apt-get update && sudo apt-get install -y gawk autoconf2.69
RUN sudo apt-get install -y vim

# Clone relocatable
RUN git clone https://github.com/dra27/relocatable.git

WORKDIR relocatable

RUN git submodule update --init ocaml

# Configure Git
WORKDIR ocaml
RUN git config --local user.name 'David Allsopp'
RUN git config --local user.email 'david.allsopp@metastack.com'
# Ensure the normal merge style is in effect or rerere doesn't appear to work!
RUN git config --local merge.conflictstyle merge
# Enable rerere with ~10 year retention of resolutions
RUN git config --local rerere.enabled true
RUN git config --local gc.rerereResolved 3650
# Speed up reconfiguration stage by sharing config.status
RUN git config --local ocaml.configure-cache ..
# Necessary for some of the more complicated rebasing
RUN git config --local merge.renameLimit 150000
# Check commits created by the script (disable the configure check)
RUN sed -e '/If any/iexit $STATUS' tools/pre-commit-githook > ../.git/modules/ocaml/hooks/pre-commit
RUN chmod +x ../.git/modules/ocaml/hooks/pre-commit
# Sync with upstream
RUN git remote add upstream https://github.com/ocaml/ocaml.git --fetch
RUN git checkout relocatable-locks

FROM base AS lock-ef758648dd
RUN test -n "$(git branch relocatable-locks --contains 'ef758648dd' 2>/dev/null)" || git fetch origin && git reset --hard origin/relocatable-locks
RUN script --return --command '../stack ef758648dd' ../log
FROM base AS lock-b026116679
RUN test -n "$(git branch relocatable-locks --contains 'b026116679' 2>/dev/null)" || git fetch origin && git reset --hard origin/relocatable-locks
RUN script --return --command '../stack b026116679' ../log
FROM base AS lock-511e988096
RUN test -n "$(git branch relocatable-locks --contains '511e988096' 2>/dev/null)" || git fetch origin && git reset --hard origin/relocatable-locks
RUN script --return --command '../stack 511e988096' ../log
FROM base AS lock-d2939babd4
RUN test -n "$(git branch relocatable-locks --contains 'd2939babd4' 2>/dev/null)" || git fetch origin && git reset --hard origin/relocatable-locks
RUN script --return --command '../stack d2939babd4' ../log
FROM base AS lock-be8c62d74b
RUN test -n "$(git branch relocatable-locks --contains 'be8c62d74b' 2>/dev/null)" || git fetch origin && git reset --hard origin/relocatable-locks
RUN script --return --command '../stack be8c62d74b' ../log
FROM base AS lock-c007288549
RUN test -n "$(git branch relocatable-locks --contains 'c007288549' 2>/dev/null)" || git fetch origin && git reset --hard origin/relocatable-locks
RUN script --return --command '../stack c007288549' ../log
FROM base AS lock-061acc735f
RUN test -n "$(git branch relocatable-locks --contains '061acc735f' 2>/dev/null)" || git fetch origin && git reset --hard origin/relocatable-locks
RUN script --return --command '../stack 061acc735f' ../log
FROM base AS lock-9cb60e14d4
RUN test -n "$(git branch relocatable-locks --contains '9cb60e14d4' 2>/dev/null)" || git fetch origin && git reset --hard origin/relocatable-locks
RUN script --return --command '../stack 9cb60e14d4' ../log

FROM base AS collect
WORKDIR /home/opam
COPY --from=lock-ef758648dd /home/opam/relocatable/log lock-ef758648dd
COPY --from=lock-b026116679 /home/opam/relocatable/log lock-b026116679
COPY --from=lock-511e988096 /home/opam/relocatable/log lock-511e988096
COPY --from=lock-d2939babd4 /home/opam/relocatable/log lock-d2939babd4
COPY --from=lock-be8c62d74b /home/opam/relocatable/log lock-be8c62d74b
COPY --from=lock-c007288549 /home/opam/relocatable/log lock-c007288549
COPY --from=lock-061acc735f /home/opam/relocatable/log lock-061acc735f
COPY --from=lock-9cb60e14d4 /home/opam/relocatable/log lock-9cb60e14d4
COPY --chmod=755 <<EOF display.sh
#!/bin/sh

echo "Lock ef758648dd: $(git -C relocatable/ocaml log -1 --format=%s ef758648dd)"
sed -e '1,/^Backport summary/d;/^Script done on/d' lock-ef758648dd
echo "Lock b026116679: $(git -C relocatable/ocaml log -1 --format=%s b026116679)"
sed -e '1,/^ - Trees differ/d;/^Script done on/d' lock-b026116679
echo "Lock 511e988096: $(git -C relocatable/ocaml log -1 --format=%s 511e988096)"
sed -e '1,/^ - Trees differ/d;/^Script done on/d' lock-511e988096
echo "Lock d2939babd4: $(git -C relocatable/ocaml log -1 --format=%s d2939babd4)"
sed -e '1,/^ - Trees differ/d;/^Script done on/d' lock-d2939babd4
echo "Lock be8c62d74b: $(git -C relocatable/ocaml log -1 --format=%s be8c62d74b)"
sed -e '1,/^ - Trees differ/d;/^Script done on/d' lock-be8c62d74b
echo "Lock c007288549: $(git -C relocatable/ocaml log -1 --format=%s c007288549)"
sed -e '1,/^ - Trees differ/d;/^Script done on/d' lock-c007288549
echo "Lock 061acc735f: $(git -C relocatable/ocaml log -1 --format=%s 061acc735f)"
sed -e '1,/^ - Trees differ/d;/^Script done on/d' lock-061acc735f
echo "Lock 9cb60e14d4: $(git -C relocatable/ocaml log -1 --format=%s 9cb60e14d4)"
sed -e '1,/^ - Trees differ/d;/^Script done on/d' lock-9cb60e14d4
EOF
