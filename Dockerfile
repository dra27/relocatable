FROM ocaml/opam:ubuntu-22.04-opam

RUN sudo apt-get update && sudo apt-get install -y gawk autoconf2.69
RUN sudo apt-get install -y vim

# Clone relocatable
RUN git clone https://github.com/dra27/relocatable.git

WORKDIR relocatable

RUN git submodule update --init ocaml

# Populate the rerere cache
RUN mkdir -p .git/modules/ocaml/rr-cache
RUN git --work-tree=.git/modules/ocaml/rr-cache checkout origin/rr-cache -- .

# Configure Git
WORKDIR ocaml
# Enable rerere with ~10 year retention of resolutions
RUN git config --local rerere.enabled true
RUN git config --local gc.rerereResolved 3650
# Speed up reconfiguration stage by sharing config.status
RUN git config --local ocaml.configure-cache ..
# Necessary for some of the more complicated rebasing
RUN git config --local merge.renameLimit 150000
# Check commits created by the script (disable the configure check)
RUN sed -e '/If any/iexit $STATUS' tools/pre-commit-githook > ../.git/modules/ocaml/hooks/pre-commit
# Sync with upstream
RUN git remote add upstream https://github.com/ocaml/ocaml.git --fetch

# Stack 'em, pack 'em and rack 'em
RUN ../stack
