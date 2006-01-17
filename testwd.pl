#! c:\perl\bin\perl.exe

use strict;
use File::MSWord;

my $file = shift || die "You must enter a filename.\n";
die "File not found.\n" unless (-e $file);

my $doc = File::MSWord::new($file);
my %streams = $doc->listStreams();
map{print "Stream : ".$_."\n";}(keys %streams);
print "\n";

my %trash = $doc->readTrash();
printf "%-15s %-8s\n","Trash Bin","Size";
map{printf "%-15s %-8d\n",$_,$trash{$_}{size}}(keys %trash); 
print "\n";

my ($l,$u) = $doc->getGUID();
printf "GUID : %x - %x\n",$l,$u;
print "\n";

my %sum = $doc->getSummaryInfo();
map{print "$_ => $sum{$_}\n"}(keys %sum);
print "\n";

# Read last 10 authors info
my ($ofs,$size) = $doc->getSavedBy();
printf "0x%x -> 0x%x\n",$ofs,$size;
my $buff = $doc->readStreamTable($ofs,$size);
my %revlog = $doc->parseSTTBF($buff,"author","path");
foreach my $k (sort {$a <=> $b} keys %revlog) {
	printf "%-4s %-15s %-60s\n",$k,$revlog{$k}{author},$revlog{$k}{path};
}
print "\n";
my %bin = $doc->getDocBinaryData();
print "Binary data:\n";
map{printf "$_ => 0x%x\n",$bin{$_}}(keys %bin);
print "\n";
print "Lang ID = ".$doc->getLangID($bin{langid})."\n";
print "\n";
