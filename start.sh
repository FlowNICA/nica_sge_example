#!/bin/bash

#
# Set up working directory (must exist before start.sh is executed)
#$ -wd /scratch2/$USER/TMP
# Tells job manager (SGE) to run job from the working directory
#$ -cwd
# Name of the job
#$ -N run_job_name
# Set partition (there's only 1 here: all.q)
#$ -q all.q
# Set up hard time limit (HH:MM:SS)
#$ -l h_rt=10:10:10
# Set up soft time limit (HH:MM:SS)
#$ -l s_rt=10:10:10
# Set up number of jobs in the array
#$ -t 1-48
#
# Set up directory where output from SGE will be stored
#$ -o /scratch2/$USER/TMP
# Set up directory where error logs from SGE will be stored
#$ -e /scratch2/$USER/TMP
#

# To submit the job array, run:
# qsub start.sh

# Set up SGE environment variables: job id and task id: jobId_taskId
# (for example, 875434_1 ... 875434_100; 875434 - jobId, 1 ... 100 - taskId)
export JOB_ID=$JOB_ID
export TASK_ID=$SGE_TASK_ID

# Source cvmfs and load up the needed software
source /cvmfs/nica.jinr.ru/sw/os/login.sh
module add mpdroot

# You can set a number of environment variables here (if needed)
export MAIN_DIR=/scratch1/parfenov/Soft/example_batch
export ROOT_MACRO=${MAIN_DIR}/readMcDst.C

# If the job requires an input, you can set it right here (list of inputs for all jobs in the array)
export INPUT_FILELIST=${MAIN_DIR}/file.list
# Each job element from the array can read its own file from the list
# (for example, 875434_1 will read 1-st line from file.list, 875434_5 will read 5-th line, etc.)
export CURRENT_FILE=`sed "${TASK_ID}q;d" $INPUT_FILELIST`

# You can set an output (and temporary) directories
export OUT=${MAIN_DIR}/OUT/${JOB_ID}
export OUT_LOG=${OUT}/log
export OUT_TXT=${OUT}/txt
export OUT_FILE=${OUT}/files
export OUTPUT=${OUT_FILE}/JOB_${JOB_ID}_${TASK_ID}.root
export LOG=${OUT_LOG}/JOB_${JOB_ID}_${TASK_ID}.log
export TXT=${OUT_TXT}/JOB_${JOB_ID}_${TASK_ID}.txt
#export TMPALL=${MAIN_DIR}/TMP
#export TMPDIR=${TMPALL}/TMP_${JOB_ID}_${TASK_ID}

#mkdir -p $TMPDIR
mkdir -p $OUT
mkdir -p $OUT_LOG
mkdir -p $OUT_FILE
mkdir -p $OUT_TXT
touch $LOG

# You can print out any entries in the log file
echo "Current file: $CURRENT_FILE" &>>$LOG
echo "Output file : $OUTPUT" &>>$LOG
echo "Output txt file: $TXT" &>>$LOG

# Execute ROOT macro or compiled executable here
root -l -b -q ${ROOT_MACRO}'("'${CURRENT_FILE}'","'${OUTPUT}'","'${TXT}'")' &>> $LOG

#rm -rfv $TMPDIR &>> $LOG
echo "Job is done!" &>> $LOG
