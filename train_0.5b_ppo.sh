#!/bin/bash

export N_GPUS=1
export BASE_MODEL=Qwen/Qwen2.5-0.5B
export DATA_DIR=./data
export ROLLOUT_TP_SIZE=1
export EXPERIMENT_NAME=countdown-Qwen-Qwen2.5-0.5B-rtx3090ti
export VLLM_ATTENTION_BACKEND=XFORMERS

/home/edward/Documents/virtualenv/zero/bin/python3 -m verl.trainer.main_ppo \
    data.train_files=$DATA_DIR/train.parquet \
    data.val_files=$DATA_DIR/test.parquet \
    data.train_batch_size=2 \
    data.val_batch_size=2 \
    data.max_prompt_length=256 \
    data.max_response_length=1024 \
    actor_rollout_ref.model.path=$BASE_MODEL \
    critic.model.path=$BASE_MODEL \
    actor_rollout_ref.actor.optim.lr=1e-6 \
    actor_rollout_ref.actor.ppo_mini_batch_size=2 \
    actor_rollout_ref.actor.ppo_micro_batch_size=1 \
    actor_rollout_ref.rollout.log_prob_micro_batch_size=1 \
    actor_rollout_ref.rollout.tensor_model_parallel_size=$ROLLOUT_TP_SIZE \
    actor_rollout_ref.rollout.gpu_memory_utilization=0.2 \
    actor_rollout_ref.ref.log_prob_micro_batch_size=1 \
    critic.optim.lr=1e-5 \
    critic.ppo_micro_batch_size=1 \
    +actor_rollout_ref.actor.fsdp_config.model_dtype=bf16 \
    +actor_rollout_ref.ref.fsdp_config.model_dtype=bf16 \
    +critic.model.fsdp_config.model_dtype=bf16 \
    +actor_rollout_ref.actor.fsdp_config.mixed_precision.reduce_dtype=bf16 \
    +actor_rollout_ref.actor.fsdp_config.mixed_precision.buffer_dtype=bf16 \
    +critic.model.fsdp_config.mixed_precision.reduce_dtype=bf16 \
    +critic.model.fsdp_config.mixed_precision.buffer_dtype=bf16 \
    algorithm.kl_ctrl.kl_coef=0.001 \
    trainer.logger=['wandb'] \
    +trainer.val_before_train=False \
    trainer.default_hdfs_dir=null \
    trainer.n_gpus_per_node=$N_GPUS \
    trainer.nnodes=1 \
    trainer.save_freq=10 \
    trainer.test_freq=10 \
    trainer.project_name=TinyZero \
    trainer.experiment_name=$EXPERIMENT_NAME \
    trainer.total_epochs=15 2>&1 | tee verl_demo.log

    #actor_rollout_ref.model.path="/home/edward/Documents/git_clone/TinyZero/checkpoints/TinyZero/countdown-qwen2.5-0.5b-rtx3090ti/actor/global_step_430" \
    #critic.model.path="/home/edward/Documents/git_clone/TinyZero/checkpoints/TinyZero/countdown-qwen2.5-0.5b-rtx3090ti/critic/global_step_430" \
    #actor_rollout_ref.model.path=$BASE_MODEL \
    #critic.model.path=$BASE_MODEL \
