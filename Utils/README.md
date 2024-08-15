# Utils
This folder contains scripts or example utility files.

## insert_git_repo_into_docker.sh
Puts the ClinSV repo files mounted to /app/clinsv to replace all scripts being used to run ClinSV in the docker container.

## resource_available.json 
Example json file to be used with the `-j` command. Modify the respective `walltime=hh:mm:ss,ncpus=X,mem=YGB,jobfs=ZGB` to restrict resources used per step. By default, ClinSV will use the same resource restrictions as resource_available.json 

- `walltime=hh:mm:ss`: This sets the maximum amount of real time the job may use. It’s called “wall time” because it’s the actual time as would be measured by a clock on the wall. The format is hours:minutes:seconds. If your job exceeds this time, it will be terminated.
- `ncpus=X`: This sets the number of CPU cores that the job can use. Replace ‘X’ with the number of cores you want to allocate to your job.
- `mem=YGB`: This sets the maximum amount of RAM memory that the job can use. Replace ‘Y’ with the amount of memory you want to allocate to your job. The ‘GB’ indicates that the value is in gigabytes.
- `jobfs=ZGB`: This sets the amount of disk space that the job can use for temporary storage. Replace ‘Z’ with the amount of disk space you want to allocate to your job. The ‘GB’ indicates that the value is in gigabytes.