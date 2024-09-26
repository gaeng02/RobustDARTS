#!/bin/bash
#
# submit to the right queue
#SBATCH -p batch_grad
#SBATCH --gres gpu:1
#SBATCH --cpus-per-gpu 8
#SBATCH --mem-per-gpu 29G
#SBATCH -a 1-1
#SBATCH -t 1-0
#SBATCH -J DARTS-ADA_grid
#
# the execution will use the current directory for execution (important for relative paths)
#SBATCH -D .
#
# redirect the output/error to some files
#SBATCH -o ./experiments/cluster_logs/%A_%a.o
#SBATCH -e ./experiments/cluster_logs/%A_%a.e
#
#

/data/$USER/anaconda3/bin/conda init
source activate darts

python src/search/train_search.py --data /local_datasets/darts --unrolled --job_id $SLURM_ARRAY_JOB_ID --task_id $SLURM_ARRAY_TASK_ID --seed $SLURM_ARRAY_TASK_ID --cutout --report_freq_hessian 2 --space $1 --dataset $2 --drop_path_prob 0.0 --weight_decay 0.0003 --save experiments/search_logs_ada --early_stop 3 --extra_rollback_epochs 0 --max_weight_decay 0.03 --mul_factor 10 --compute_hessian

