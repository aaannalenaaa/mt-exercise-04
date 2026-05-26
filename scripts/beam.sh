#!/bin/bash
scripts=$(dirname "$0")
base=$scripts/..
data=$base/data
configs=$base/configs

translations=$base/translations
results=$base/results

mkdir -p $translations $results

src=it
trg=en

model_name=transformer_bpe_4k
base_config=$configs/$model_name.yaml

output_csv=$results/beam_results.csv

echo "beam,bleu,time_seconds" > $output_csv

for beam_size in 1 2 4 5 6 7 8 10 12 20; do
    echo "========================================="
    echo "Beam size: $beam_size"
    echo "========================================="

    tmp_config=$results/tmp_${model_name}_beam${beam_size}.yaml
    cp $base_config $tmp_config
    sed -i "" "s/beam_size: .*/beam_size: $beam_size/" $tmp_config

    output_file=$translations/test.beam${beam_size}.${trg}
    SECONDS=0

    PYTORCH_ENABLE_MPS_FALLBACK=1 OMP_NUM_THREADS=8 \
    python -m joeynmt translate $tmp_config \
        < $data/test.$src \
        > $output_file

    bleu=$(sacrebleu $data/test.$trg -i $output_file -m bleu -b)
    echo "$beam_size,$bleu,$SECONDS" >> $output_csv
    echo "$beam_size done in $SECONDS seconds"
done

echo "Done. Results: $output_csv"