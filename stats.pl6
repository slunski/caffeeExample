
my @file = @*ARGS[0].IO.lines;

my $compiler;
my @times;


sub avg( @l ) {
	my $avg = ([+] @l) / @l.elems;
	return $avg;
}

sub var( @l ) {
	my $avg = ([+] @l) / @l.elems;
	my @diffs2 = @l.map: { exp(2,($_ - $avg)) };
	my $var = ([+] @diffs2) / @l.elems;
	return $var;
}
for @file {
	next if /^\#/;
	push @times, $_ if /^\d/;
	$compiler = $_ if /^Rakudo\x20v/ or /^perl6\x20v/;
	if /^$/ {
		if @times.elems != 0 {
			#$compiler ~~ /(\d\d\d\d\.\d\d).+\x20 built\x20on\x20(MoarVM|parrot)/;
			$compiler ~~ /(\d\d\d\d\.\d\d)/;
			my $pver = $0;
			$compiler ~~ /(MoarVM|parrot)\x20[version\x20]?(.+)$/;
			my $c = $0;
			my $cv = $1;
			say ~$pver, " $c $cv:  avg: ", avg( @times ), "  σ: ", sqrt( var( @times ) );
			$compiler = $_;
			@times = ();
		}
	}
	#say $l.perl;

}




