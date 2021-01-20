#!/bin/bash
#SBATCH --output run_job_creator.job.o%j.txt
#SBATCH --error run_job_creator.job.e%j.txt
#SBATCH --mail-user palombagia@dei.unipd.it
#SBATCH --mail-type ALL
#SBATCH --time 100:00:00
#SBATCH --ntasks 1
#SBATCH -c 1
#SBATCH --exclude=gpu1,gpu2,runner-07,runner-08,runner-13,runner-14,runner-15,runner-16,runner-17,runner-18,runner-19
#SBATCH --partition allgroups
#SBATCH --mem 16G


srun matlab < crea_job_LesionsMask_4_slurm.m
