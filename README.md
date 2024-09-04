<img src="clinsv_logo.png" alt="drawing" width="180"/>

Robust detection of clinically relevant structural and copy number variation from whole genome sequencing data

Microarrays have been the mainstay for detecting clinically relevant copy number variants (CNV) in patients. Whole genome sequencing (WGS) has the potential to provide far higher resolution of CNV detection and to resolve structural variation (SV) invisible to current microarrays. Current WGS-based approaches however have high error rates, poor reproducibility, and difficulties in annotating, visualizing, and prioritizing rare variants. 

We developed ClinSV to overcome these challenges, enabling the use of WGS to identify short, and large CNV and balanced SV, with high analytical sensitivity, reproducibility, and low false positive rates. ClinSV is designed to be easily integrated into production WGS analysis pipelines, and generate output which is easily interpreted by researchers and clinicians. We developed ClinSV mostly in the context of analysing WGS data from a single-lane of an Illumina HiSeq X sequencer, thus ~30-40x coverage. We focused mostly on the use of ClinSV to identify rare, gene-affecting variation in the context of rare genetic disease. We have used it to detect Mitochondrial SV, and somatic SV from tumour-normal paired WGS.

ClinSV has the following features:

* Integration of three CNV signals: depth of coverage, split and spanning reads
* Extensive quality attributes for CNV and SV
* CNV and copy-number neutral SV are assigned High, Pass, Low quality tranches
* Variant segregation if a user-supplied PED file is supplied
* Gene and phenotype annotation of each SV
* Full, and focussed result tables for easy clinical interpretation
* Quality Control report
* Analytical validaiton report, if NA12878 is being analysed
* Multiple population allele frequency measures to help identify rare variants 
* Visualisation framework via IGV and multiple supporting tracks


For 500 WGS [samples](misc/control_sample_IDs.txt) of the Medical Genome Reference Bank population, allele frequencies were derived from split-reads, discordant pairs, depth of coverage changes and ClinSV calls. This allows to also filter out common low confident variant calls and sequencing artefacts.

Please refer to the [manuscript](https://doi.org/10.1186/s13073-021-00841-x) for further details.


# ClinSV version 1.1.0
This repository contains the source code and Docker files required to run ClinSV version 1.1.0. This version supports both GRCh38 and GRCh37 decoy (hs37d5) reference genomes.

The easiest way to run ClinSV is via Docker. If you really want to compile from source, then see [INSTALL_b38.md](INSTALL_b38.md).

## Release Notes - v1.1.0  
- Able to to use either ref-genomes on the fly depending on the file path passed into the `-ref` command. `-ref /app/ref-data/refdata-b38` for GRCh38 (b38) and `-ref /app/ref-data/refdata-b37` for GRCh38 (b37).
- Support of hg19 style nomenclature (ex `1,2,3,4..X,Y,MT`) for input bams using the b37 reference genome. Note this is an unstable feature. It is recommended to lift over your bam files first to the ref genome you would want to use.
-  Able to use maximum available CPUs for the bigwig:createWigs and lumpy:caller steps.
- Able to limit the amount of CPUs used by ClinSV with the `-j` command where a path to a json file which contains the max limit on resources used for each step is passed as input. For more details see [here](Utils/).
- Added script to make a smoother development experience using the docker container. For more details see [here](Utils/).
- Bug fix #61: igv .xml file now uses the correct reference genome dependeant on the reference genome used.
- Bug fix #60: the coverage by chromosome view in the QC report is now outputed correctly.



## Download
ClinSV requires a reference genome to run. Currently only GRCh38 and GRCh37 decoy (hs37d5) reference genomes are supported.

### GRCh38 (b38) files
Download human genome reference data GRCh38 (37GB):

```
wget https://clinsv.s3.ccia.org.au/clinsv_b38/refdata-b38_v1.0.tar
tar xf refdata-b38_v1.0.tar
```

Download a sample bam to test ClinSV (71GB):

```
wget https://clinsv.s3.ccia.org.au/clinsv_b38/NA12878_b38.bam
wget https://clinsv.s3.ccia.org.au/clinsv_b38/NA12878_b38.bam.bai
```
or a smaller subsampled BAM file (4.7GB)
```
wget https://clinsv.s3.ccia.org.au/clinsv_b38/NA12878.grch38.subsampled.bam
wget https://clinsv.s3.ccia.org.au/clinsv_b38/NA12878.grch38.subsampled.bam.bai
```

### GRCh37 (b37) files
Download human genome reference data GRCh37 decoy (hs37d5):

```
wget https://clinsv.s3.ccia.org.au/clinsv_b37/refdata-b37_v0.9.tar
# check md5sum: 921ecb9b9649563a16e3a47f25954951
tar xf refdata-b37_v0.9.tar
```

Download a sample bam to test ClinSV:

```
wget https://clinsv.s3.ccia.org.au/clinsv_b37/NA12878_v0.9.bam
wget https://clinsv.s3.ccia.org.au/clinsv_b37/NA12878_v0.9.bam.bai
```

## File structure to run Docker image

In order to use the docker image with the docker run instructions, your working directory needs to be set up as below:
```
Current working directory
|    |contains your bam files *.bam
|    |contains your bai files *.bai
└───clinsv
|    └───refdata-b3x
|          | /all of refdata-b3x's content/  
└───test_run
      | this is where clinsv generates all its output
```
**Extract the refdata-b3x tar files in the clinsv folder**

## Run ClinSV
### Using Docker
```
docker pull containerregistrypubliccb.azurecr.io/clinsv:v1.1.0


refdata_path=$PWD/clinsv/
input_path=$PWD
project_folder=$PWD/test_run

docker run -v $refdata_path:/app/ref-data \
-v $project_folder:/app/project_folder  \
-v $input_path:/app/input  \
--entrypoint "perl" containerregistrypubliccb.azurecr.io/clinsv:v1.1.0 /app/clinsv/bin/clinsv \
-r all \
-p /app/project_folder/ \
-i "/app/input/*.bam" \
-ref /app/ref-data/refdata-b3x \
-w
```
Expect this to take ~8 hours for a 30x WGS 80GB BAM file.

Expect this to take ~2.5 hours with the subsampled 4.7GB BAM file.

### Using Singularity
Currently only ClinSV v0.9 is supported on Singularity, as such, only the GRCh37 decoy (hs37d5) reference genome and respecitvely aligned BAMs can be used.
```
wget https://clinsv.s3.ccia.org.au/clinsv_b37/clinsv.sif
singularity run clinsv.sif \
  -i "$input_path/*.bam" \
  -ref $refdata_path \
  -p $PWD/project_folder
```
### Linux Native

Download precompiled ClinSV bundle for CentOS 6.8 x86_64. Also only uses ClinSV v0.9, as such, only the GRCh37 decoy (hs37d5) reference genome and respecitvely aligned BAMs can be used.

```
wget https://clinsv.s3.ccia.org.au/clinsv_b37/ClinSV_x86_64_v0.9.tar.gz
tar zxf ClinSV_x86_64_v0.9.tar.gz
clinsv_path=$PWD/clinsv
export PATH=$clinsv_path/bin:$PATH
clinsv -r all -p $PWD/project_folder -i "$input_path/*.bam" -ref $refdata_path
```
## ClinSV usage and options

```
### This script runs ClinSV on a single node ###
Version: v1.1.0
Author: Andre E Minoche, James Bradley, Mark J Cowley

usage: clinsv -p /path/to/project -i /path/to/input_bams/*.bam -ref /path/to/ref_data [options]

### Options:
-p Project folder [current_dir]. This can take two colon separated values, see README.md
-r Analysis steps to run [all]. All is equivalent to bigwig,lumpy,cnvnator,annotate,prioritize,qc,igv
   Multiple steps must be comma separated with no spaces in-between.
-i Path to input bams [./input/*.bam]. Requires bam index ending to be \"*.bam.bai.\". 
   Bam and index files can also be soft-links.
-s Sample information file [./sampleInfo.txt] If not set and if not already present, 
   such file gets generated from bam file names.
-f Force specified analysis step(s) and overwrite existing output.
-a Ask for confirmation before launching next analysis step.
-n Name stem for joint-called files (e.g joint vcf file) in case different sample grouping exists. 
   This is necessary if different sets of samples specified wtih -s are analysed within the same 
   project folder, E.g. a family trio and a set of single proband individuals.
-w short for 'web': In the IGV session file, stream the annotation tracks from a server. Convenient if you
    prefer to run ClinSV on an HPC (where you have a copy of the annotation bundle) and view results on your desktop 
-j Path to json file which specifies the resources to be used for each step
-l Lumpy batch size. Number of sampels to be joint-called [15]. 
-ref Path to reference data dir [./refdata-b38 or ./refdata-b37]. This can take two colon separated values, see README.md
-hg19 Specify that input bams use hg19 chromosome nomenclature (e.g. short form '1,2,3..X,Y,MT'), use when using input bams that are
      aligned to hg19. Ensure to use with the reference data refdata-b37. Warning this is an unstable feature. Highly recommend to lift over input bams to
      GRCh37/GRCh38 with another tool, then use ClinSV with those ref genomes.
-eval Create the NA12878 validation report section [no].
-h print this help

# To rerun a specific analysis steps:
clinsv -r annotsv,prioritize -f
```

### Advanced options
When providing a [pedigree file](misc/sampleInfo.ped), the output will contain additional columns showing e.g. how often a variant was observed among affected and unaffected individuals. The pedigree file has to be named "sampleInfo.ped" and it has to be placed into the project folder.

To mark variants affecting user defined candidate genes, a [gene list](misc/testGene.ids) list has to be placed into the project folder and named "testGene.ids". Gene names have to be as in ENSEMBL GRCh37.

### Compile dependencies from source
see [INSTALL.md](INSTALL.md)


## Hardware requirements
* based on 30-40x WGS (80GB BAM file): 16 CPUs, 60GB RAM, 200 GB storage


## Output


### QC report


> results/[sample.QC_report.pdf](results_test_data/sample.QC_report.pdf)

Quality control metrics, including a detailed description.


### Variant files

> results/[sample.RARE_PASS_GENE.xlsx](results_test_data/sample.RARE_PASS_GENE.xlsx)

Rare gene affecting variants, one variant per line. Recommended to open in Excel or OpenOffice calc.

> SVs/joined/SV-CNV.vcf, .txt or .xlsx

All variants

### Results description

For instructions on how to interprete the results, see:
> results/[result\_description.docx](results_test_data/result_description.docx)

and the manuscript (see section citation)

### IGV session file

> igv/sample.xml

This IGV genome browser session file contains paths to supporting data files necessary for manual inspection of variants. There are tracks from static annotation files and those from your sample(s) of interest.

If ClinSV was executed on a remote computer, like an HPC, or **within a docker container** then the file paths might not work on your Desktop. The default option of `-p /app/project_folder/` creates resource paths like this:

  <Resource path="/app/project_folder/test_run/igv/alignments/Sample/bw/Sample.q0.bw"/>

You have several options to improve this:

1. The `-p` parameter accepts two arguments, the first is the desired path on your desktop/localhost, the second is the path on the execution host where the job needs to run. For example `-p /path/on/desktop:/app/project_folder/`. In this case the session.xml will have
```
<Resource path="/path/on/desktop/test_run/igv/alignments/Sample/bw/Sample.q0.bw"/>
```
Once you copy the results to `/path/on/desktop`, the session file will now work.

2. paths can be relative to the igv xml file, so `-p ..:/app/project_folder/` will create:
```
<Resource path="../alignments/Sample/bw/Sample.q0.bw"/>
```

3. manually replace the paths in the XML file with a perl regex, eg `perl -pi -e 's|/app/project_folder/|/path/on/desktop/|g' $xml`

4. mount the remote folder on your desktop (eg sshfs) using the same folder structure

When the IGV application is open, the hyperlinks within the `sample.RARE_PASS_GENE.xlsx` file will open session files and to navigate to variants.

For more information please see the publication.

## Dev tips
ClinSV works by creating shell scripts which aggregate multiple tools together. How these scripts are defined is specified in [main clinsv perl script](clinsv). These are then run for each job. There are 6 jobs run by clinsv `bigwig,lumpy,cnvnator,annotate,prioritize,qc`. These are defined as functions with the same name in the [main clinsv perl script](clinsv). They all contain sub-jobs:

```
    "bigwig":{
            "createWigs",
            "q0",
            "q20",
            "mq"
    },
    "lumpy":{
            "caller",
            "depth"
    },
    "cnvnator":{
            "caller"
    },
    "annotate":{
            "main"
    },
    "prioritize":{
            "main"
    },
    "qc":{
            "main"
    }

```
### Container Development
Installing the dependencies for ClinSV can be quite hard. It is recommended that development in done in the provided docker container. There is two ways to approach this:
#### Method 1: Developing outside the container then attaching dev volumes.
1. Set up your dev working directory as the same file structure used to run the docker image.
2. Download all required reference genomes and sample BAM files (use subsampled bam for quicker performance testing) and place them in the respective folders described in step 1.
3. Set the environment variables used to mount the volumes to the docker container. As described in the run docker container instructions.
4. Git clone/pull clinsv into the current working directory
5. Set a ClinSV repo path environment variable to the cloned/pulled ClinSV git repo: `clinsv_repo_path=$PWD/ClinSV/`
6. Run the docker of latest version of ClinSV in interactive mode mounting the `clinsv_repo_path variable` to the app folder in the docker container: `docker run -v $refdata_path:/app/ref-data
-v $project_folder:/app/project_folder 
-v $input_path:/app/input 
-v $clinsv_repo_path:/app/clinsv_repo
-it containerregistrypubliccb.azurecr.io/clinsv:v1.1.0`
7. Write dev changes to the ClinSV repo and save.
8. In the running docker container run: `sh /app/clinsv_repo/Utils/insert_git_repo_into_docker.sh`. This will apply all the changes made in the ClinSV repo outside the container to the appropriate areas in the ClinSV docker container.
9. Run ClinSV inside the container to test changes.

#### Method 2: Developing inside the container directly.
1. Using Visual Studio Code, download the [Visual Studio Code Dev Containers extension](https://code.visualstudio.com/docs/devcontainers/containers).
2. Set up your dev working directory as the same file structure used to run the docker image.
3. Download all required reference genomes and sample BAM files (use subsampled bam for quicker performance testing) and place them in the respective folders described in step 1.
4. Set the environment variables used to mount the volumes to the docker container. As described in the run docker container instructions.
`docker run -v $refdata_path:/app/ref-data
-v $project_folder:/app/project_folder 
-v $input_path:/app/input 
-it containerregistrypubliccb.azurecr.io/clinsv:v1.1.0`
5. Using the Visual Studio Code Dev Containers extension attach VS code to the running container. 
6. In the running container create the folder `/app/clinsv_repo/`.
7. Git clone ClinSV into `/app/clinsv_repo/`.
8. Write dev changes to the ClinSV repo and save. This is done nicely using VS code.
9. In the running docker container run: `sh /app/clinsv_repo/Utils/insert_git_repo_into_docker.sh`. This will apply all the changes made in the `/app/clinsv_repo/` to the appropriate areas in the ClinSV docker container.
10. Run ClinSV inside the container to test changes.
 
## Commonly asked questions (FAQ)
1. Does ClinSV support long read data (Nanopore or PacBio)? No.
2. Does ClinSV work on targeted short read NGS data (eg WES or panels)? No, it only works on WGS.
3. Does ClinSV work on NovaSeq data? Yes it should be fine, but the control data was generated on HiSeq X & much of the strength of ClinSV is removing the noise that can happen when searching genome-wide.
4. Why does my BAM not work? You must have one sample name 'SM' defined in the BAM header.
5. Can I run hundreds of BAM files through ClinSV? We mostly tested ClinSV on trios or small numbers of WGS, so this probably won't work.
6. Will you support CRAM? Yes, one day.
7. Can I use hg19? Yes. Support of hg19 style nomenclature (ex `1,2,3,4..X,Y,MT`) for input bams using the b37 reference genome using the `-hg19` command. Note this is an unstable feature. It is recommended to lift over your bam files first to the ref genome you would want to use (GRCh38 or GRCh37).
8. Do you support alt/no alts? ClinSV should accept any of the versions of GRCh38, but will only analyse CNV or SV on the autosomes, and allosomes (X and Y).
9. Will ClinSV work on model organisms? We've never tried. The annotation files and control data are important features of ClinSV, so it probably isn't the best choice.

## Licence

ClinSV is free for research and education purposes, please refer to [ClinSV licence](LICENCE.md) agreement for full terms. For clinical or commercial use, please contact bdi[at]garvan.org.au for additional information.

## Citation

Minoche AE, Lundie B, Peters GB, Ohnesorg T, Pinese M, Thomas DM, et al. ClinSV: clinical grade structural and copy number variant detection from whole genome sequencing data. Genome Medicine. 2021;13:32. 

[Manuscript](https://doi.org/10.1186/s13073-021-00841-x)

