use strict;
#use warnings;

my $FOfile=$ARGV[0]; #The outfile file from FastOrtho
my $Pfamfile=$ARGV[1]; #The outfile from PfamScan

my %families=FAMS($FOfile);

foreach my $key (sort keys %families){
	#print("$key\n");
	my @familynumber=split(/L/,$key);
	#print("$familynumber[1]\n");
	my $genecount=1;
	foreach my $geneID (@{%families{$key}}){
		#print("$geneID\n");
		my @IDs=split(/\(|\)/,$geneID);
		#print("$IDs[0]\t$IDs[1]\n")
		my $domains=`grep -P "$IDs[0]\t" $Pfamfile | grep $IDs[1] | wc -l`;
		chomp $domains;		
		print("gen$familynumber[1]\_$genecount\t$domains\n");
		$genecount++;
	}
}


# - # - # - # - # - # - #
sub FAMS{
my $file=shift;
my %dictionary;
open(FILE,$file)or die $!;
my $count =1;
foreach my $line (<FILE>){
	chomp $line;
	#print "$count\n";
	$count++; 
	my @family=split(/\s|\:/,$line);
	#print("$family[0]\n");
	my @genegroup=split(/\t/,$line);
	$genegroup[1]=~s/^\s+//;
	#print("$genegroup[1]\n");
	my @genes=split(/\s/,$genegroup[1]);
	my @genesarray=();
	foreach my $gene(@genes){
		my @genename=split(/\|/,$gene);
		#print("$genename[6]\n");
		push(@genesarray,$genename[6]);
	}	
	#print("@genesarray\n");
	@{$dictionary{$family[0]}}=@genesarray;
	#print("@{$dictionary{$family[0]}}");
	
} 
close FILE;
return %dictionary
}
# - # - # - # - # - # - #
