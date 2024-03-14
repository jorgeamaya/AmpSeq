version 1.0

workflow ampseq {
	input {	
		#General commands
		String path_to_fq 
		String pattern_fw = "*_L001_R1_001.fastq.gz"
		String pattern_rv = "*_L001_R2_001.fastq.gz"

		#Commands for AmpSeq
		String Class = "parasite"
		String maxEE = "5,5"
		String trimRight = "0,0"
		Int minLen = 30
		String truncQ = "5,5"
		String matchIDs = "0"
		Int max_consist = 10
		Float omegaA = 0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
		String saveRdata = ""
		Int justConcatenate = 0
		Int maxMismatch = 0
		String no_ref = 'False'
		String adjust_mode = "absolute"
		String strain = "3D7"
		String strain2 = "DD2"
		String polyN = "5"
		String min_reads = "0"
		String min_samples = "0"
		String max_snv_dist = "-1"
		String max_indel_dist = "-1"
		String include_failed = "False"
		String exclude_bimeras = "False"

		#Command for the decontamination pipeline
		Int minreads_threshold = 1000
		Float contamination_threshold = 0.5
		String verbose = "False"		

#		String type_of_reads
#		File path_to_flist
#		File pr1
#		File pr2
#		File overlap_pr1
#		File overlap_pr2
#		File path_to_snv
#		File reference
#		File reference2
	}

	call ampseq_pipeline {
		input:
			path_to_fq = path_to_fq,
			pattern_fw = pattern_fw,
			pattern_rv = pattern_rv,
			Class = Class,
			maxEE = maxEE,
			trimRight = trimRight,
			minLen = minLen,
			truncQ = truncQ,
			matchIDs = matchIDs,
			max_consist = max_consist,
			omegaA = omegaA,
			saveRdata = saveRdata,
			justConcatenate = justConcatenate,
			maxMismatch = maxMismatch,
			no_ref = no_ref,
			adjust_mode = adjust_mode,
			strain = strain,
			strain2 = strain2,
			polyN = polyN,
			min_reads = min_reads,
			min_samples = min_samples,
			max_snv_dist = max_snv_dist,
			max_indel_dist = max_indel_dist,
			include_failed = include_failed,
			exclude_bimeras = exclude_bimeras,
			minreads_threshold = minreads_threshold,
			contamination_threshold = contamination_threshold,
			verbose = verbose
	}
}

task ampseq_pipeline {
	input {
		String path_to_fq 
		String pattern_fw = "*_L001_R1_001.fastq.gz"
		String pattern_rv = "*_L001_R2_001.fastq.gz"
		String Class = "parasite"
		String maxEE = "5,5"
		String trimRight = "0,0"
		Int minLen = 30
		String truncQ = "5,5"
		String matchIDs = "0"
		Int max_consist = 10
		Float omegaA = 0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
		String saveRdata = ""
		Int justConcatenate = 0
		Int maxMismatch = 0
		String no_ref = 'False'
		String adjust_mode = "absolute"
		String strain = "3D7"
		String strain2 = "DD2"
		String polyN = "5"
		String min_reads = "0"
		String min_samples = "0"
		String max_snv_dist = "-1"
		String max_indel_dist = "-1"
		String include_failed = "False"
		String exclude_bimeras = "False"
		Int minreads_threshold = 1000
		Float contamination_threshold = 0.5
		String verbose = "False"
	}

	Map[String, String] in_map = {
		"path_to_fq": "fq_dir",
		"pattern_fw": pattern_fw,
		"pattern_rv": pattern_rv,
		"Class": Class,
		"maxEE": maxEE,
		"trimRight": trimRight,
		"minLen": minLen,
		"truncQ": truncQ,
		"matchIDs": matchIDs,
		"max_consist": max_consist,
		"omegaA": omegaA,
		"saveRdata": saveRdata,
		"justConcatenate": justConcatenate,
		"maxMismatch": maxMismatch,
		"no_ref": no_ref,
		"adjust_mode": adjust_mode,
		"strain": strain,
		"strain2": strain2,
		"polyN": polyN,
		"min_reads": min_reads,
		"min_samples": min_samples,
		"max_snv_dist": max_snv_dist,
		"max_indel_dist": max_indel_dist,
		"include_failed": include_failed,
		"exclude_bimeras": exclude_bimeras,
		"minreads_threshold": minreads_threshold,
		"contamination_threshold": contamination_threshold,
		"verbose": verbose,
		"path_to_flist": 'barcodes_matches.csv',
		"pr1": 'primers_fw.fasta',
		"pr2": 'primers_rv.fasta'
	}
	File config_json = write_json(in_map)
	command <<<
	set -euxo pipefail
	#set -x
	mkdir fq_dir

	gsutil ls ~{path_to_fq}
	gsutil -m cp -r ~{path_to_fq}* fq_dir/

	#Move reference files to the main level
	mv fq_dir/barcodes_matches.csv .
	mv fq_dir/primers_*.fasta .
	mv fq_dir/snv_filters.txt .
	
	if [ -f fq_dir/*ref_1.fasta ]; then mv fq_dir/reference_panel_1.fasta .; fi
	if [ -f fq_dir/*ref_2.fasta ]; then mv fq_dir/reference_panel_2.fasta .; fi
	
	# Read the first line of the file
	first_line=$(head -n 1 "barcodes_matches.csv")

	# Check if the first line matches the expected pattern
	if [ "$first_line" = "sample_id,Forward,Reverse" ]; then
		echo "Sequencing run with inline barcodes. Performing analysis of combinatorial indices followed by denoising"
		find . -type f		
		python Code/Amplicon_TerraPipeline.py --config config.json --terra --meta --adaptor_removal --contamination --separate_reads --primer_removal --dada2 --postproc_dada2 --asv_to_cigar
		Rscript /render_report.R -d "/Report/Merge/" -o "/Report/" -p "/barcodes_matches.csv" -m 1000 -c 0.5 -mf "/Results/missing_files.tsv"
		tar -csvf Report_Cards.tar.gz Report
		find . -type f	
	else
		echo "Sequencing run without inline barcodes. Skipping analysis of combinatorial indices and performing only denoising"
		python Code/Amplicon_TerraPipeline.py --config config.json --terra --meta --adaptor_removal --separate_reads --primer_removal --dada2 --postproc_dada2 --asv_to_cigar
	fi
	
	>>>
	output {
		File? ASVBimeras = "Results/ASVBimeras.txt"
		File? CIGARVariants_Bfilter = "Results/CIGARVariants_Bfilter.out.tsv"
		File? ASV_to_CIGAR = "Results/ASV_to_CIGAR/ASV_to_CIGAR.out.txt"
		File? seqtab = "Results/seqtab.tsv"
		File? ASVTable = "Results/PostProc_DADA2/ASVTable.txt"
		File? ASVSeqs = "Results/PostProc_DADA2/ASVSeqs.fasta"
		File? missing_files = "Results/missing_files.tsv"
		File? decontamination_sample_cards = "Report_Cards.tar.gz"
		File? decontamination_report = "Results/ci_report_layouting.html"
	}
	runtime {
		cpu: 1
		memory: "15 GiB"
		disks: "local-disk 10 HDD"
		bootDiskSizeGb: 10
		preemptible: 3
		maxRetries: 1
		docker: 'jorgeamaya/mixed_reads_ampseq'
	}
}

