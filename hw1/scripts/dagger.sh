#!/bin/bash
# NOTE: This script is used for better grouping of experiment data, and the data 
# generated by this script does not follow the homework submission specifications.  

export PYTHONPATH=.

video_log_freq=5
eval_batch_size=10000
num_agent_train_steps_per_iter=5000
n_iter=10

DATA_DIR=./data
EXP_DIR=${DATA_DIR}/dagger/`date +%Y-%m-%d_%H-%M-%S`
LOG_PATH=${EXP_DIR}/log.txt
# clear other data files
rm -rf $(find ${DATA_DIR} -maxdepth 1 -name '*q2_*' 2> /dev/null)
# create data directory for this experiment and logfile
mkdir -p $EXP_DIR; touch $LOG_PATH
# dump experiment commands and hyperparameters (this file) to logfile
cat $0 >> $LOG_PATH; echo "\n\n" >> $LOG_PATH

for env in Ant Humanoid Walker2d HalfCheetah Hopper
do 
    python -m cs285.scripts.run_hw1 \
        --expert_policy_file cs285/policies/experts/${env}.pkl \
        --env_name ${env}-v2 --exp_name dagger_${env} --n_iter ${n_iter} \
        --do_dagger --expert_data cs285/expert_data/expert_data_${env}-v2.pkl \
        --eval_batch_size ${eval_batch_size} \
        --num_agent_train_steps_per_iter ${num_agent_train_steps_per_iter} \
        --video_log_freq ${video_log_freq} >> $LOG_PATH
done

mv $(find ${DATA_DIR} -maxdepth 1 -name '*q2_*' 2> /dev/null) $EXP_DIR
