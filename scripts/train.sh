#! /bin/bash
scripts=$(dirname "$0")
base=$scripts/..

for model_name in transformer_word transformer_bpe_2k transformer_bpe_4k; do
    echo "========================================="
    echo "Starting training: $model_name"
    echo "========================================="
    
    mkdir -p $base/logs/$model_name
    
    SECONDS=0
    PYTORCH_ENABLE_MPS_FALLBACK=1 OMP_NUM_THREADS=8 python -m joeynmt train \
        $base/configs/$model_name.yaml \
        > $base/logs/$model_name/out \
        2> $base/logs/$model_name/err
    
    echo "$model_name done in $SECONDS seconds"
done

echo "All models trained."