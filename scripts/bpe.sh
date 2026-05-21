#!/bin/bash
scripts=$(dirname "$0")
base=$scripts/..
data=$base/data


for vocabsize in 2000 4000; do
  if [ "$vocabsize" -eq 2000 ]; then
    vocab=2k
    echo "Learning BPE with vocab size 2000"
  else
    vocab=4k
    echo "Learning BPE with vocab size 4000"
  fi

  subword-nmt learn-joint-bpe-and-vocab \
    -i $data/train.it $data/train.en \
    -s $vocabsize \
    --write-vocabulary $data/vocab_${vocab}.it $data/vocab_${vocab}.en \
    -o $data/bpe_${vocab}.codes

  cat $data/vocab_${vocab}.it $data/vocab_${vocab}.en \
  | cut -f1 -d' ' | sort | uniq > $data/vocab_${vocab}.joint
done

