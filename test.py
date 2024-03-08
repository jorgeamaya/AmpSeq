

def distance(str1, str2):
    #Calculate the Hamming Distance
    if len(str1) != len(str2):
        raise ValueError("Input strings must have the same length")
    
    distance = 0
    for i in range(len(str1)):
        if str1[i] != str2[i]:
            distance += 1
    return distance

def demultiplex_fastq_pair(forward_file, reverse_file, primer_forward, primer_reverse, mismatches, output_dir, amplicon):
    forward_records = []
    reverse_records = []

    text_string = f"{forward_file} {reverse_file} {primer_forward} {primer_reverse} {mismatches} {output_dir} {amplicon}"
    print(text_string)

    read_n = 0
    # Read the input FASTQ files and demultiplex
    with open(os.path.join("Fastq", forward_file), 'r') as forward_fastq, open(os.path.join("Fastq", reverse_file), 'r') as reverse_fastq:
        for forward_record, reverse_record in zip(SeqIO.parse(forward_fastq, 'fastq'), SeqIO.parse(reverse_fastq, 'fastq')):
            #print(forward_record)
            #print(reverse_record)
            len_f = len(primer_forward)
            len_r = len(primer_reverse)
            read_n = read_n + 1
            if distance(primer_forward, str(forward_record.seq[:len_f])) <= mismatches and distance(primer_reverse, str(reverse_record.seq[:len_r])) <= mismatches:
                forward_records.append(forward_record)
                reverse_records.append(reverse_record)

    # Write demultiplexed FASTQ files
    forward_output_file = f"{output_dir}/{amplicon}/{forward_file}"
    reverse_output_file = f"{output_dir}/{amplicon}/{reverse_file}"

    print(forward_output_file)
    print(reverse_output_file)

    with open(forward_output_file, 'w') as forward_output, open(reverse_output_file, 'w') as reverse_output:
        SeqIO.write(forward_records, forward_output, 'fastq')
        SeqIO.write(reverse_records, reverse_output, 'fastq')

def retrieve_primers(forward_file, reverse_file):
	primer_dict = {}
	with open(forward_file, 'r') as forward_fasta, open(reverse_file, 'r') as reverse_fasta:
		for forward_record, reverse_record in zip(SeqIO.parse(forward_file, 'fasta'), SeqIO.parse(reverse_file, 'fasta')):
			if forward_record.id == reverse_record.id:
				primer_dict[forward_record.id] = {forward_record.seq, reverse_record.seq}
		return primer_dict


forward_file = '/Users/jorgeamaya/Desktop/Broad_Test/Benchmarking/Data_Repo_Guyana_Ministry_of_Health_2023_12_05/fastq/G1M008_S58_L001_R1_001.fastq.gz'
reverse_file = '/Users/jorgeamaya/Desktop/Broad_Test/Benchmarking/Data_Repo_Guyana_Ministry_of_Health_2023_12_05/fastq/G1M008_S58_L001_R2_001.fastq.gz'

#
#    os.makedirs('Results')
#    for primer_name in primer_dict.keys():
#      os.makedirs(f'Results/{primer_name}') 
#    
#    files = os.listdir('/Users/jorgeamaya/Desktop/Raquel_Demultiplexing_iSeq/Fastq')
#    filtered_files = [filename.split('_', 2)[0] + '_' + filename.split('_', 2)[1] for filename in files]
#
#    print(filtered_files)
#    for primer_name, sequences in primer_dict.items():
#      fwd_sequence, rev_sequence = sequences
#
#      for file in filtered_files:
#        print(file)
#        forward_fastq = f"{file}_L001_R1_001.fastq"
#        reverse_fastq = f"{file}_L001_R2_001.fastq"
#        output_directory = "Results"
#        amplicon = primer_name
#        primer_forward = fwd_sequence
#        primer_reverse = rev_sequence  # Replace with your primer sequences
#        allowed_mismatches = 50
#
#        demultiplex_fastq_pair(forward_fastq, reverse_fastq, primer_forward, primer_reverse, allowed_mismatches, output_directory, amplicon)
#
