FROM ocaml/opam:ubuntu-24.04-opam AS base

RUN <<End-of-Script
  sudo apt-get update -y
  sudo apt-get install -y gawk autoconf2.69 vim
End-of-Script

RUN <<End-of-Script
  # Global Git configuration
  git config --global user.name 'David Allsopp'
  git config --global user.email 'david.allsopp@metastack.com'
  git config --global protocol.file.allow always

  # Clone relocatable
  git clone https://github.com/dra27/relocatable.git

  # Clone ocaml
  cd relocatable
  git submodule update --init ocaml

  cd ocaml
  git remote add --fetch upstream https://github.com/ocaml/ocaml.git

  # Configure Git
  # Explicitly set user.name and user.email (for reproducibility)
  git config --local user.name 'David Allsopp'
  git config --local user.email 'david.allsopp@metastack.com'
  # Ensure the normal merge style is in effect or rerere doesn't appear to work!
  git config --local merge.conflictstyle merge
  # Enable rerere with ~10 year retention of resolutions
  git config --local rerere.enabled true
  git config --local gc.rerereResolved 3650
  # Speed up reconfiguration stage by sharing config.status
  git config --local ocaml.configure-cache ..
  # Necessary for some of the more complicated rebasing
  git config --local merge.renameLimit 150000

  # Set-up the pre-commit githook
  # Require ocaml/ocaml#14050
  git show origin/pre-commit:tools/pre-commit-githook     | sed -e '/If any/iexit $STATUS'       > ../.git/modules/ocaml/hooks/pre-commit
  chmod +x ../.git/modules/ocaml/hooks/pre-commit

  git checkout relocatable-locks
End-of-Script

FROM base AS builder
RUN <<End-of-Script
  git clone --shared relocatable build
  cd build
  git submodule init ocaml
  git clone /home/opam/relocatable/ocaml --shared --no-checkout .git/modules/ocaml
  mv .git/modules/ocaml/.git/* .git/modules/ocaml/
  rmdir .git/modules/ocaml/.git
  cp ../relocatable/.git/modules/ocaml/hooks/pre-commit .git/modules/ocaml/hooks/
  git submodule update ocaml
  cd ocaml
  git remote set-url origin https://github.com/dra27/ocaml.git
  git remote add --fetch upstream https://github.com/ocaml/ocaml.git

  # Configure Git
  # Explicitly set user.name and user.email (for reproducibility)
  git config --local user.name 'David Allsopp'
  git config --local user.email 'david.allsopp@metastack.com'
  # Ensure the normal merge style is in effect or rerere doesn't appear to work!
  git config --local merge.conflictstyle merge
  # Enable rerere with ~10 year retention of resolutions
  git config --local rerere.enabled true
  git config --local gc.rerereResolved 3650
  # Speed up reconfiguration stage by sharing config.status
  git config --local ocaml.configure-cache ..
  # Necessary for some of the more complicated rebasing
  git config --local merge.renameLimit 150000
End-of-Script
WORKDIR /home/opam/build/ocaml

FROM builder AS lock-ef758648dd
RUN test -n "$(git branch relocatable-locks --contains 'ef758648dd' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack ef758648dd || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack ef758648dd || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-b026116679
RUN test -n "$(git branch relocatable-locks --contains 'b026116679' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack b026116679 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack b026116679 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-511e988096
RUN test -n "$(git branch relocatable-locks --contains '511e988096' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 511e988096 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 511e988096 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-d2939babd4
RUN test -n "$(git branch relocatable-locks --contains 'd2939babd4' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack d2939babd4 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack d2939babd4 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-be8c62d74b
RUN test -n "$(git branch relocatable-locks --contains 'be8c62d74b' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack be8c62d74b || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack be8c62d74b || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-c007288549
RUN test -n "$(git branch relocatable-locks --contains 'c007288549' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack c007288549 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack c007288549 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-061acc735f
RUN test -n "$(git branch relocatable-locks --contains '061acc735f' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 061acc735f || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 061acc735f || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-9cb60e14d4
RUN test -n "$(git branch relocatable-locks --contains '9cb60e14d4' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 9cb60e14d4 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 9cb60e14d4 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-54d34a7a07
RUN test -n "$(git branch relocatable-locks --contains '54d34a7a07' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 54d34a7a07 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 54d34a7a07 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-1fec8b02bf
RUN test -n "$(git branch relocatable-locks --contains '1fec8b02bf' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 1fec8b02bf || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 1fec8b02bf || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-68507ab524
RUN test -n "$(git branch relocatable-locks --contains '68507ab524' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 68507ab524 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 68507ab524 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-344465c433
RUN test -n "$(git branch relocatable-locks --contains '344465c433' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 344465c433 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 344465c433 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-9a16d2c854
RUN test -n "$(git branch relocatable-locks --contains '9a16d2c854' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 9a16d2c854 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 9a16d2c854 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-d5a626cfd4
RUN test -n "$(git branch relocatable-locks --contains 'd5a626cfd4' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack d5a626cfd4 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack d5a626cfd4 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-818afcc496
RUN test -n "$(git branch relocatable-locks --contains '818afcc496' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 818afcc496 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 818afcc496 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM base AS collector-0
COPY --chown=opam:opam --from=lock-ef758648dd /home/opam/build/.git/modules/ocaml builds/ef758648dd/.git
COPY --from=lock-ef758648dd /home/opam/build/log logs/log-ef758648dd
COPY --chown=opam:opam --from=lock-b026116679 /home/opam/build/.git/modules/ocaml builds/b026116679/.git
COPY --from=lock-b026116679 /home/opam/build/log logs/log-b026116679
COPY --chown=opam:opam --from=lock-511e988096 /home/opam/build/.git/modules/ocaml builds/511e988096/.git
COPY --from=lock-511e988096 /home/opam/build/log logs/log-511e988096
COPY --chown=opam:opam --from=lock-d2939babd4 /home/opam/build/.git/modules/ocaml builds/d2939babd4/.git
COPY --from=lock-d2939babd4 /home/opam/build/log logs/log-d2939babd4
COPY --chown=opam:opam --from=lock-be8c62d74b /home/opam/build/.git/modules/ocaml builds/be8c62d74b/.git
COPY --from=lock-be8c62d74b /home/opam/build/log logs/log-be8c62d74b
COPY --chown=opam:opam --from=lock-c007288549 /home/opam/build/.git/modules/ocaml builds/c007288549/.git
COPY --from=lock-c007288549 /home/opam/build/log logs/log-c007288549
COPY --chown=opam:opam --from=lock-061acc735f /home/opam/build/.git/modules/ocaml builds/061acc735f/.git
COPY --from=lock-061acc735f /home/opam/build/log logs/log-061acc735f
COPY --chown=opam:opam --from=lock-9cb60e14d4 /home/opam/build/.git/modules/ocaml builds/9cb60e14d4/.git
COPY --from=lock-9cb60e14d4 /home/opam/build/log logs/log-9cb60e14d4
COPY --chown=opam:opam --from=lock-54d34a7a07 /home/opam/build/.git/modules/ocaml builds/54d34a7a07/.git
COPY --from=lock-54d34a7a07 /home/opam/build/log logs/log-54d34a7a07
COPY --chown=opam:opam --from=lock-1fec8b02bf /home/opam/build/.git/modules/ocaml builds/1fec8b02bf/.git
COPY --from=lock-1fec8b02bf /home/opam/build/log logs/log-1fec8b02bf
COPY --chown=opam:opam --from=lock-68507ab524 /home/opam/build/.git/modules/ocaml builds/68507ab524/.git
COPY --from=lock-68507ab524 /home/opam/build/log logs/log-68507ab524
COPY --chown=opam:opam --from=lock-344465c433 /home/opam/build/.git/modules/ocaml builds/344465c433/.git
COPY --from=lock-344465c433 /home/opam/build/log logs/log-344465c433
COPY --chown=opam:opam --from=lock-9a16d2c854 /home/opam/build/.git/modules/ocaml builds/9a16d2c854/.git
COPY --from=lock-9a16d2c854 /home/opam/build/log logs/log-9a16d2c854
COPY --chown=opam:opam --from=lock-d5a626cfd4 /home/opam/build/.git/modules/ocaml builds/d5a626cfd4/.git
COPY --from=lock-d5a626cfd4 /home/opam/build/log logs/log-d5a626cfd4
COPY --chown=opam:opam --from=lock-818afcc496 /home/opam/build/.git/modules/ocaml builds/818afcc496/.git
COPY --from=lock-818afcc496 /home/opam/build/log logs/log-818afcc496

FROM builder AS lock-727272c2ee
RUN test -n "$(git branch relocatable-locks --contains '727272c2ee' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 727272c2ee || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 727272c2ee || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-8d9989f22a
RUN test -n "$(git branch relocatable-locks --contains '8d9989f22a' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 8d9989f22a || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 8d9989f22a || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-032059697e
RUN test -n "$(git branch relocatable-locks --contains '032059697e' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 032059697e || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 032059697e || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-b3cef089c9
RUN test -n "$(git branch relocatable-locks --contains 'b3cef089c9' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack b3cef089c9 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack b3cef089c9 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-0dc23f3111
RUN test -n "$(git branch relocatable-locks --contains '0dc23f3111' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 0dc23f3111 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 0dc23f3111 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-af068161ce
RUN test -n "$(git branch relocatable-locks --contains 'af068161ce' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack af068161ce || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack af068161ce || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-240c86c340
RUN test -n "$(git branch relocatable-locks --contains '240c86c340' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 240c86c340 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 240c86c340 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-6370253918
RUN test -n "$(git branch relocatable-locks --contains '6370253918' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 6370253918 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 6370253918 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-c37031be15
RUN test -n "$(git branch relocatable-locks --contains 'c37031be15' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack c37031be15 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack c37031be15 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-a0c452bb00
RUN test -n "$(git branch relocatable-locks --contains 'a0c452bb00' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack a0c452bb00 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack a0c452bb00 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-a051f6e271
RUN test -n "$(git branch relocatable-locks --contains 'a051f6e271' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack a051f6e271 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack a051f6e271 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-c013d8555a
RUN test -n "$(git branch relocatable-locks --contains 'c013d8555a' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack c013d8555a || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack c013d8555a || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-590e211336
RUN test -n "$(git branch relocatable-locks --contains '590e211336' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack 590e211336 || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack 590e211336 || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-b5aa73d89c
RUN test -n "$(git branch relocatable-locks --contains 'b5aa73d89c' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack b5aa73d89c || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack b5aa73d89c || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM builder AS lock-ce46c921dd
RUN test -n "$(git branch relocatable-locks --contains 'ce46c921dd' 2>/dev/null)" || { git -C .. pull origin main && git fetch --multiple upstream origin && git checkout -B relocatable-locks origin/relocatable-locks ; }
RUN script --return --command '../stack ce46c921dd || { echo "STACK FAILURE"; rm -f ../.stack-state; git reset --hard HEAD; git clean -dfx &>/dev/null; }' ../log
RUN sed -i '/use_caching=/s/1/0/' ../stack
RUN script --return --append  --command '../stack ce46c921dd || echo "STACK FAILURE"' ../log
RUN git gc --no-prune && sed -i -e '/worktree/d' ../.git/modules/ocaml/config

FROM base AS collector-1
COPY --chown=opam:opam --from=lock-727272c2ee /home/opam/build/.git/modules/ocaml builds/727272c2ee/.git
COPY --from=lock-727272c2ee /home/opam/build/log logs/log-727272c2ee
COPY --chown=opam:opam --from=lock-8d9989f22a /home/opam/build/.git/modules/ocaml builds/8d9989f22a/.git
COPY --from=lock-8d9989f22a /home/opam/build/log logs/log-8d9989f22a
COPY --chown=opam:opam --from=lock-032059697e /home/opam/build/.git/modules/ocaml builds/032059697e/.git
COPY --from=lock-032059697e /home/opam/build/log logs/log-032059697e
COPY --chown=opam:opam --from=lock-b3cef089c9 /home/opam/build/.git/modules/ocaml builds/b3cef089c9/.git
COPY --from=lock-b3cef089c9 /home/opam/build/log logs/log-b3cef089c9
COPY --chown=opam:opam --from=lock-0dc23f3111 /home/opam/build/.git/modules/ocaml builds/0dc23f3111/.git
COPY --from=lock-0dc23f3111 /home/opam/build/log logs/log-0dc23f3111
COPY --chown=opam:opam --from=lock-af068161ce /home/opam/build/.git/modules/ocaml builds/af068161ce/.git
COPY --from=lock-af068161ce /home/opam/build/log logs/log-af068161ce
COPY --chown=opam:opam --from=lock-240c86c340 /home/opam/build/.git/modules/ocaml builds/240c86c340/.git
COPY --from=lock-240c86c340 /home/opam/build/log logs/log-240c86c340
COPY --chown=opam:opam --from=lock-6370253918 /home/opam/build/.git/modules/ocaml builds/6370253918/.git
COPY --from=lock-6370253918 /home/opam/build/log logs/log-6370253918
COPY --chown=opam:opam --from=lock-c37031be15 /home/opam/build/.git/modules/ocaml builds/c37031be15/.git
COPY --from=lock-c37031be15 /home/opam/build/log logs/log-c37031be15
COPY --chown=opam:opam --from=lock-a0c452bb00 /home/opam/build/.git/modules/ocaml builds/a0c452bb00/.git
COPY --from=lock-a0c452bb00 /home/opam/build/log logs/log-a0c452bb00
COPY --chown=opam:opam --from=lock-a051f6e271 /home/opam/build/.git/modules/ocaml builds/a051f6e271/.git
COPY --from=lock-a051f6e271 /home/opam/build/log logs/log-a051f6e271
COPY --chown=opam:opam --from=lock-c013d8555a /home/opam/build/.git/modules/ocaml builds/c013d8555a/.git
COPY --from=lock-c013d8555a /home/opam/build/log logs/log-c013d8555a
COPY --chown=opam:opam --from=lock-590e211336 /home/opam/build/.git/modules/ocaml builds/590e211336/.git
COPY --from=lock-590e211336 /home/opam/build/log logs/log-590e211336
COPY --chown=opam:opam --from=lock-b5aa73d89c /home/opam/build/.git/modules/ocaml builds/b5aa73d89c/.git
COPY --from=lock-b5aa73d89c /home/opam/build/log logs/log-b5aa73d89c
COPY --chown=opam:opam --from=lock-ce46c921dd /home/opam/build/.git/modules/ocaml builds/ce46c921dd/.git
COPY --from=lock-ce46c921dd /home/opam/build/log logs/log-ce46c921dd

FROM base AS collector
COPY --chown=opam:opam --from=collector-0 /home/opam/builds builds
COPY --chown=opam:opam --from=collector-0 /home/opam/logs logs
COPY --chown=opam:opam --from=collector-1 /home/opam/builds builds
COPY --chown=opam:opam --from=collector-1 /home/opam/logs logs

FROM collector AS reflog
RUN <<End-of-Script
  for lock in ef758648dd b026116679 511e988096 d2939babd4 be8c62d74b c007288549 061acc735f 9cb60e14d4 54d34a7a07 1fec8b02bf 68507ab524 344465c433 9a16d2c854 d5a626cfd4 818afcc496 727272c2ee 8d9989f22a 032059697e b3cef089c9 0dc23f3111 af068161ce 240c86c340 6370253918 c37031be15 a0c452bb00 a051f6e271 c013d8555a 590e211336 b5aa73d89c ce46c921dd; do
    cat builds/$lock/.git/logs/HEAD
  done > HEAD
End-of-Script

FROM base AS unified
COPY --chown=opam:opam --from=collector /home/opam/builds builds
COPY --chown=opam:opam --from=collector /home/opam/logs logs
COPY --from=reflog /home/opam/HEAD .
RUN cat HEAD >> relocatable/.git/modules/ocaml/logs/HEAD && rm -f HEAD
COPY <<EOF relocatable/.git/modules/ocaml/objects/info/alternates
/home/opam/builds/ef758648dd/.git/objects
/home/opam/builds/b026116679/.git/objects
/home/opam/builds/511e988096/.git/objects
/home/opam/builds/d2939babd4/.git/objects
/home/opam/builds/be8c62d74b/.git/objects
/home/opam/builds/c007288549/.git/objects
/home/opam/builds/061acc735f/.git/objects
/home/opam/builds/9cb60e14d4/.git/objects
/home/opam/builds/54d34a7a07/.git/objects
/home/opam/builds/1fec8b02bf/.git/objects
/home/opam/builds/68507ab524/.git/objects
/home/opam/builds/344465c433/.git/objects
/home/opam/builds/9a16d2c854/.git/objects
/home/opam/builds/d5a626cfd4/.git/objects
/home/opam/builds/818afcc496/.git/objects
/home/opam/builds/727272c2ee/.git/objects
/home/opam/builds/8d9989f22a/.git/objects
/home/opam/builds/032059697e/.git/objects
/home/opam/builds/b3cef089c9/.git/objects
/home/opam/builds/0dc23f3111/.git/objects
/home/opam/builds/af068161ce/.git/objects
/home/opam/builds/240c86c340/.git/objects
/home/opam/builds/6370253918/.git/objects
/home/opam/builds/c37031be15/.git/objects
/home/opam/builds/a0c452bb00/.git/objects
/home/opam/builds/a051f6e271/.git/objects
/home/opam/builds/c013d8555a/.git/objects
/home/opam/builds/590e211336/.git/objects
/home/opam/builds/b5aa73d89c/.git/objects
/home/opam/builds/ce46c921dd/.git/objects
EOF
WORKDIR /home/opam/relocatable/ocaml
RUN <<End-of-Script
  cat >> rebuild <<"EOF"
  head="$(git -C ../../builds/ef758648dd rev-parse --short relocatable-cache)"
  for lock in b026116679 511e988096 d2939babd4 be8c62d74b c007288549 061acc735f 9cb60e14d4 54d34a7a07 1fec8b02bf 68507ab524 344465c433 9a16d2c854 d5a626cfd4 818afcc496 727272c2ee 8d9989f22a 032059697e b3cef089c9 0dc23f3111 af068161ce 240c86c340 6370253918 c37031be15 a0c452bb00 a051f6e271 c013d8555a 590e211336 b5aa73d89c ce46c921dd; do
    while IFS= read -r line; do
      args=($line)
      if [[ ${#args[@]} -gt 2 ]]; then
        parents=("${args[@]:3}")
        head=$(git show --no-patch --format=%B ${args[0]} | git commit-tree -p $head ${parents[@]/#/-p } ${args[1]})
      fi
    done < <(git -C ../../builds/$lock log --format='%h %t %p' --first-parent --reverse relocatable-cache)
  done
  git branch relocatable-cache $head
EOF
  bash rebuild
  rm rebuild
End-of-Script

FROM unified AS cache-test-ef758648dd
RUN script --return --command "../stack ef758648dd" ../log

FROM unified AS cache-test-b026116679
RUN script --return --command "../stack b026116679" ../log

FROM unified AS cache-test-511e988096
RUN script --return --command "../stack 511e988096" ../log

FROM unified AS cache-test-d2939babd4
RUN script --return --command "../stack d2939babd4" ../log

FROM unified AS cache-test-be8c62d74b
RUN script --return --command "../stack be8c62d74b" ../log

FROM unified AS cache-test-c007288549
RUN script --return --command "../stack c007288549" ../log

FROM unified AS cache-test-061acc735f
RUN script --return --command "../stack 061acc735f" ../log

FROM unified AS cache-test-9cb60e14d4
RUN script --return --command "../stack 9cb60e14d4" ../log

FROM unified AS cache-test-54d34a7a07
RUN script --return --command "../stack 54d34a7a07" ../log

FROM unified AS cache-test-1fec8b02bf
RUN script --return --command "../stack 1fec8b02bf" ../log

FROM unified AS cache-test-68507ab524
RUN script --return --command "../stack 68507ab524" ../log

FROM unified AS cache-test-344465c433
RUN script --return --command "../stack 344465c433" ../log

FROM unified AS cache-test-9a16d2c854
RUN script --return --command "../stack 9a16d2c854" ../log

FROM unified AS cache-test-d5a626cfd4
RUN script --return --command "../stack d5a626cfd4" ../log

FROM unified AS cache-test-818afcc496
RUN script --return --command "../stack 818afcc496" ../log

FROM unified AS cache-test-727272c2ee
RUN script --return --command "../stack 727272c2ee" ../log

FROM unified AS cache-test-8d9989f22a
RUN script --return --command "../stack 8d9989f22a" ../log

FROM unified AS cache-test-032059697e
RUN script --return --command "../stack 032059697e" ../log

FROM unified AS cache-test-b3cef089c9
RUN script --return --command "../stack b3cef089c9" ../log

FROM unified AS cache-test-0dc23f3111
RUN script --return --command "../stack 0dc23f3111" ../log

FROM unified AS cache-test-af068161ce
RUN script --return --command "../stack af068161ce" ../log

FROM unified AS cache-test-240c86c340
RUN script --return --command "../stack 240c86c340" ../log

FROM unified AS cache-test-6370253918
RUN script --return --command "../stack 6370253918" ../log

FROM unified AS cache-test-c37031be15
RUN script --return --command "../stack c37031be15" ../log

FROM unified AS cache-test-a0c452bb00
RUN script --return --command "../stack a0c452bb00" ../log

FROM unified AS cache-test-a051f6e271
RUN script --return --command "../stack a051f6e271" ../log

FROM unified AS cache-test-c013d8555a
RUN script --return --command "../stack c013d8555a" ../log

FROM unified AS cache-test-590e211336
RUN script --return --command "../stack 590e211336" ../log

FROM unified AS cache-test-b5aa73d89c
RUN script --return --command "../stack b5aa73d89c" ../log

FROM unified AS cache-test-ce46c921dd
RUN script --return --command "../stack ce46c921dd" ../log

FROM unified AS collected-logs
COPY --from=cache-test-ef758648dd /home/opam/relocatable/log combined-ef758648dd
COPY --from=cache-test-b026116679 /home/opam/relocatable/log combined-b026116679
COPY --from=cache-test-511e988096 /home/opam/relocatable/log combined-511e988096
COPY --from=cache-test-d2939babd4 /home/opam/relocatable/log combined-d2939babd4
COPY --from=cache-test-be8c62d74b /home/opam/relocatable/log combined-be8c62d74b
COPY --from=cache-test-c007288549 /home/opam/relocatable/log combined-c007288549
COPY --from=cache-test-061acc735f /home/opam/relocatable/log combined-061acc735f
COPY --from=cache-test-9cb60e14d4 /home/opam/relocatable/log combined-9cb60e14d4
COPY --from=cache-test-54d34a7a07 /home/opam/relocatable/log combined-54d34a7a07
COPY --from=cache-test-1fec8b02bf /home/opam/relocatable/log combined-1fec8b02bf
COPY --from=cache-test-68507ab524 /home/opam/relocatable/log combined-68507ab524
COPY --from=cache-test-344465c433 /home/opam/relocatable/log combined-344465c433
COPY --from=cache-test-9a16d2c854 /home/opam/relocatable/log combined-9a16d2c854
COPY --from=cache-test-d5a626cfd4 /home/opam/relocatable/log combined-d5a626cfd4
COPY --from=cache-test-818afcc496 /home/opam/relocatable/log combined-818afcc496
COPY --from=cache-test-727272c2ee /home/opam/relocatable/log combined-727272c2ee
COPY --from=cache-test-8d9989f22a /home/opam/relocatable/log combined-8d9989f22a
COPY --from=cache-test-032059697e /home/opam/relocatable/log combined-032059697e
COPY --from=cache-test-b3cef089c9 /home/opam/relocatable/log combined-b3cef089c9
COPY --from=cache-test-0dc23f3111 /home/opam/relocatable/log combined-0dc23f3111
COPY --from=cache-test-af068161ce /home/opam/relocatable/log combined-af068161ce
COPY --from=cache-test-240c86c340 /home/opam/relocatable/log combined-240c86c340
COPY --from=cache-test-6370253918 /home/opam/relocatable/log combined-6370253918
COPY --from=cache-test-c37031be15 /home/opam/relocatable/log combined-c37031be15
COPY --from=cache-test-a0c452bb00 /home/opam/relocatable/log combined-a0c452bb00
COPY --from=cache-test-a051f6e271 /home/opam/relocatable/log combined-a051f6e271
COPY --from=cache-test-c013d8555a /home/opam/relocatable/log combined-c013d8555a
COPY --from=cache-test-590e211336 /home/opam/relocatable/log combined-590e211336
COPY --from=cache-test-b5aa73d89c /home/opam/relocatable/log combined-b5aa73d89c
COPY --from=cache-test-ce46c921dd /home/opam/relocatable/log combined-ce46c921dd
RUN cat combined-ef758648dd combined-b026116679 combined-511e988096 combined-d2939babd4 combined-be8c62d74b combined-c007288549 combined-061acc735f combined-9cb60e14d4 combined-54d34a7a07 combined-1fec8b02bf combined-68507ab524 combined-344465c433 combined-9a16d2c854 combined-d5a626cfd4 combined-818afcc496 combined-727272c2ee combined-8d9989f22a combined-032059697e combined-b3cef089c9 combined-0dc23f3111 combined-af068161ce combined-240c86c340 combined-6370253918 combined-c37031be15 combined-a0c452bb00 combined-a051f6e271 combined-c013d8555a combined-590e211336 combined-b5aa73d89c combined-ce46c921dd > combined

FROM unified
COPY --from=collected-logs /home/opam/relocatable/ocaml/combined ../../logs/combined
COPY <<EOF ../../all-locks
ef758648dd b026116679 511e988096 d2939babd4 be8c62d74b c007288549 061acc735f 9cb60e14d4 54d34a7a07 1fec8b02bf 68507ab524 344465c433 9a16d2c854 d5a626cfd4 818afcc496 727272c2ee 8d9989f22a 032059697e b3cef089c9 0dc23f3111 af068161ce 240c86c340 6370253918 c37031be15 a0c452bb00 a051f6e271 c013d8555a 590e211336 b5aa73d89c ce46c921dd
EOF
