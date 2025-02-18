import hydra
from verl.utils.dataset.sft_dataset import SFTDataset

@hydra.main(config_path='./verl/trainer/config', config_name='ppo_trainer', version_base=None)
def main(config):
    print(f"{config.data=}")
    target = 40
    numbers = [ 96, 74, 94, 54 ]
  
    prefix =  f"""A conversation between User and Assistant. The user asks a question, and the Assistant solves it. The assistant first thinks about the reasoning process in the mind and then provides the user with the answer.
    User: Using the numbers {numbers}, create an equation that equals {target}. You can use basic arithmetic operations (+, -, *, /) and each number can only be used once. Show your work in <think> </think> tags. And return the final answer in <answer> </answer> tags, for example <answer> (1 + 2) / 3 </answer>.
    Assistant: Let me solve this step by step.
    <think>"""
    print(prefix)
    return 

main()
