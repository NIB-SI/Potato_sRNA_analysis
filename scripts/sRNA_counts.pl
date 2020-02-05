#!/usr/bin/perl
#---------------------------------------- V2.0 (C) Ench, Sep 2019, Jan 2020 --
#| Usage: sRNA_counts options files ...
#| Options:
#|   -seqtab=inpseq.fasta      - sequence selection file (fasta format)
#|   -output=outfn.csv         - tab separated output file (D=stdin)
#|   -partial                  - also match as a subsequence (D=exact match)
#|   inpfn.fasta               - input file (fasta format)
#|
#-----------------------------------------------------------------------------
use strict; use utf8; use Encode;

my($seqtab,$outf,$part,$OUT,@inpf,%seqtab,@col,%tab,$lh);
#my $debug=$ENV{DEBUG}//0;

parsecmdline(@ARGV);
%seqtab=map{s/^>//;$_} slurpfasta($seqtab);
for my $f (sort @inpf) {my($sh,$fh,$fseq,$sc); push @col,$f;
  open(INP,"<:utf8",$f) || err("$f: $!");
  while (!eof(INP) and ($fh,$fseq)=rdseq()) {$sc++;
#   printf "... %s: %d\r",$f,$sc if ($debug and !($sc%$debug));
    for $sh (keys %seqtab) {
      if ($part) {$tab{$f}{$sh}++ if (index($fseq,$seqtab{$sh})>=0)}
      else {$tab{$f}{$sh}++ if ($seqtab{$sh} eq $fseq)}
    }
  }
  close INP;
}
#printf "\e[K\n" if ($debug);
print $OUT join("\t","",map{basename($_)} @col),"\n";
for my $sh (sort keys %seqtab) {
  print $OUT join("\t",$sh,map{$tab{$_}{$sh}//0} @col),"\n";
}
close $OUT;

#-----------------------------------------------------------------------------
sub rdseq { my($h,$seq);
  while (<INP>) {chomp;s/\r$//;
    $h=$lh,$lh=$seq="" if ($lh);
    if (s/^>//) {$lh=$_,return($h,$seq) if ($h); $h=$_; $seq=""}
    elsif (defined($h)) {$seq.=$_}
  }
  return($h,$seq) if ($h);
}
#-----------------------------------------------------------------------------
sub slurpfasta { my($f)=@_; my($hdr,%seq);
  open(INP,"<:utf8",$f) || err("$f: $!");
  while (<INP>) {chomp;s/\r$//;
    if (!/^>/) {$seq{$hdr}.=$_}
    elsif (!defined($seq{$_})) {$hdr=$_}
    else {err("$f: Duplicate header ($_)")}
  }
  close INP;
  %seq;
}
#-----------------------------------------------------------------------------
sub parsecmdline {
  while (defined($_=decode_utf8(shift))) {my($k,$v)=split('=');
    if (opt($k,"-partial",2)) {$part=1}
    elsif (opt($k,"-output",2)) {$outf=defined($v)?$v:shift}
    elsif (opt($k,"-seqtab",2)) {$seqtab=defined($v)?$v:shift}
    elsif (/^-.+/) {usage()}
    elsif (! -f) {err("$_: File not found")}
    else {push @inpf,$_}
  }
  if (!@inpf or !defined($seqtab)) {usage()}
  elsif (!defined($outf)) {$OUT=\*STDOUT; $outf="(stdout)"}
  elsif (!open($OUT,">:utf8",$outf)) {err("$outf: $!")}
}
#-----------------------------------------------------------------------------
sub err {my($f)=shift; die @_?sprintf("$f\n",@_):"$f\n"}
sub usage {open(FN,"<$0") && die grep {s/^#\| ?//} <FN>}
sub opt {my($s,$k,$m)=@_; length($s)>=($m?$m:length($k)) and $k=~/^\Q$s\E/}
sub basename { my($f)=@_; $f=~s/^.*\///;$f=~s/\.(fasta|fa)$//;$f}
#-----------------------------------------------------------------------------
