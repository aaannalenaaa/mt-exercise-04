#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..

data=$base/data
configs=$base/configs

translations=$base/translations

mkdir -p $translations

src=it
trg=en


device=0

# measure time

SECONDS=0


for model_name in transformer_word transformer_bpe_2k transformer_bpe_4k; do
    echo "========================================="
    echo "model_name: $model_name"
    echo "========================================="
    

    translations_sub=$translations/$model_name

    mkdir -p $translations_sub

    PYTORCH_ENABLE_MPS_FALLBACK=1 OMP_NUM_THREADS=8 python -m joeynmt \
    translate $configs/$model_name.yaml < $data/test.$src > \
    $translations_sub/test.$model_name.$trg

    # compute case-sensitive BLEU 

    cat $translations_sub/test.$model_name.$trg | sacrebleu $data/test.$trg

    echo "$model_name done in $SECONDS seconds"

    
done

echo "All models evaluated."