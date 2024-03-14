#!/bin/bash

###############################################################################
#SCRIPT NAME: Amplicon Terra Pipeline master script    	 		      #
#DESCRIPTION: Analyse Amplicon Sequencing Data for Contamination and relevant #
#	      plasmodium phenotypes.					      #
#ARGS: No arguments						              #
#AUTHORS: J.E. Amaya Romero, Angela Early, Jason Mohabir, Phillip Schwabl     #	
#CONTACT: jamayaro@broadinstitute.org	       				      #
###############################################################################

:<<'CONFIG.JSON'
#Instructions for the CONFIG.JSON FILE

#path_to_fq: Path to input fastq files"
#pattern_fw: Pattern for forward reads in fastqs names
#pattern_rv: Pattern for reverse reads in fastqs names
#read_maxlength: Crop reads at this length. Use to avoid merging bad quality reads.
#pairread_minlength: Minimum paired read length. Use to remove unusual sequence pairs. Amplicons must be longer than this.
#merge_minlength: Minimum merge length. Use to remove unusual sequence pairs. Amplicons must be longer than this. Must be equal or shorter than pairread_minlength.
#pr1: Path to forward primers FASTA file
#pr2: Path to reverse primers FASTA file
#Class: Specify Analysis class. Accepts one of two: parasite/vector
#maxEE: Maximum Expected errors (dada2 filtering argument)
#trimRight: Hard trim number of bases at 5 end (dada2 filtering argument)
#minLen: Minimum length filter (dada2 filtering argument)
#truncQ: Soft trim bases based on quality (dada2 filtering argument)
#max_consist: Number of cycles for consistency in error model (dada2 argument)
#omegaA: p-value for the partitioning algorithm (dada2 argument)
#saveRdata: Optionally save dada2 part of this run as Rdata object
#justConcatenate: whether reads should be concatenated with N's during merge (dada2 argument)
#maxMismatch: Specify the maximum number of mismatches allowed during merging
#overlap_pr1: Path to forward primers for shorter overlapping targets FASTA file (For mixed_reads run only)
#overlap_pr2: Path to reverse primers for shorter overlapping targets FASTA file (For mixed_reads run only)
#reference: Path to reference target sequences (If --mixed_reads flag is set)
#strain: Main strain for the postprocess of DADA2 ASVs
#strain2: Optional second strain for the postprocess of DADA2 ASVs
#polyN: Mask homopolymer runs length >= polyN (default: 5; disabled < 2)
#min_reads: Minimum total reads to include ASV (default: 0, disabled)
#min_samples: Minimum samples to include ASV (default: 0, disabled)
#max_snv_dist: Maximum SNV distance to include ASV (default: -1, disabled)
#max_indel_dist: Maximum indel distance to include ASV (default: -1, disabled)
#include_failed: INCLUDE ASVs that failed post-DADA2 filters (default: False)
#exclude_bimeras: EXCLUDE ASVs that DADA2 flagged as bimeras (default: False)
#amp_mask: Amplicon low complexity mask info (default: None, disabled)
#verbose: Increase verbosity
CONFIG.JSON

#EXEC

#conda activate ampseq_env

mv Data/barcodes_matches.csv .
mv Data/primers_fw.fasta .
mv Data/primers_rv.fasta .
mv Data/pf3d7_ref_updated_v4_ref1.fasta reference_panel_1.fasta
mv Data/pfdd2_ref_updated_v3_ref2.fasta reference_panel_2.fasta
mv Data/snv_filters.txt .

python Code/Amplicon_TerraPipeline.py --config config.json --terra --meta --adaptor_removal --contamination --separate_reads --primer_removal --dada2 --postproc_dada2 --asv_to_cigar
Rscript /render_report.R -d "/Report/Merge/" -o "/Report/" -p "/barcodes_matches.csv" -m 1000 -c 0.5 -mf "/Results/missing_files.tsv"

#Tested
#python Code/Amplicon_TerraPipeline.py --config config_iSeq.json --mixed_reads \
#--meta \
#--adaptor_removal \
#--separate_reads
#--primer_removal \
#--dada2 \
#--postproc_dada2 \
#--asv_to_cigar

#Tested
#python Code/Amplicon_TerraPipeline.py --config config_MiSeq.json --overlap_reads \
#--meta \
#--adaptor_removal \
#--primer_removal \
#--dada2 \
#--postproc_dada2 \
#--asv_to_cigar
#
#Tested
#python Code/Amplicon_TerraPipeline.py --config config_MiSeq_ci.json --overlap_reads \
#--meta \
#--repo \
#--adaptor_removal \
#--contamination

#Tested
#python Code/Amplicon_TerraPipeline.py --config config_iSeq_ci.json --mixed_reads \
#--meta \
#--repo \
#--adaptor_removal \
#--contamination

#python Code/Amplicon_TerraPipeline.py --config config_MiSeq_ci.json --overlap_reads \
#--meta \
#--repo \
#--adaptor_removal \
#--contamination \
#--primer_removal \
#--dada2 \
#--postproc_dada2 \
#--asv_to_cigar

#python Code/Amplicon_TerraPipeline.py --config config_iSeq_ci.json --mixed_reads --terra \ 
#--meta \
#--repo \
#--adaptor_removal \
#--contamination #\
#--primer_removal \
#--dada2 \
#--postproc_dada2 \
#--asv_to_cigar

