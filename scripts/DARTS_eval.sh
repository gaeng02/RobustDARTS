#!/usr/bin/bash
#
# submit to the right queue
#SBATCH -p batch_ce_ugrad
#SBATCH --gres gpu:1
#SBATCH --cpus-per-gpu 8
#SBATCH --mem-per-gpu 29G
#SBATCH -a 1-1
#SBATCH -t 1-0
#SBATCH -J DARTS_grid_eval
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

python src/evaluation/train.py --data /local_datasets/darts --archs_config_file ./experiments/search_logs_baseline/results_arch.yaml --save experiments/eval_logs_baseline --cutout --auxiliary --job_id $SLURM_ARRAY_JOB_ID --task_id 1 --seed 1 --space $1 --dataset $2 --search_dp $3 --search_wd $4 --search_task_id $SLURM_ARRAY_TASK_ID

