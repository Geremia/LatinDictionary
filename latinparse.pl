#/usr/bin/perl

#I wrote this code! Yay!

$counter = 0;

while ($line = <>) {
	$abbrev = $undeclined = 0;
	$line =~ /^\#(.+)\s\s([A-Z].+)\s::\s(.+)/s;
	$latin_words = $1;
	$part_of_speech = $2;
	$definition_words = $3;

#debug
#print $1; print "\n";
#print $2; print "\n";
#print $3; print "\n";

	$latin_words =~ /^([A-Za-z.\/]+),/s;
	$first_word = $1;
	printf "<d:entry id=\"%s_%d\">\n", $1, $counter++;
	printf "\t<d:index d:value=\"%s\"\/>\n", $1, $1;
	while ($latin_words =~ /,\s([A-Za-z.\/]+)/g) {
		if ($1 =~ /undeclined/) {
			$undeclined = 1;
		} elsif ($1 =~ /abb./) {
			$abbrev = 1;
		}
		else {
			printf "\t<d:index d:value=\"%s\"\/>\n", $1, $1;
		}
	}
	while ($definition_words =~ /(\w+)/g) {
		printf "\t<d:index d:value=\"%s\"\/>\n", $1, $1;
	}
	
	printf "\t<h1>%s</h1>\n", $first_word;
	$part_of_speech =~ s/([A-Z])\s+\[/$1 \[/;
	printf "\t<span class=\"syntax\">%s</span>\n", (($undeclined==1)?"undeclined ":"").(($abbrev==1)?'abb. ':'').$part_of_speech;

	printf "\t<div>\n\t\t<ol>\n";
	while ($definition_words =~ /([^\;]+)\;/g) {
		printf "\t\t\t<li>\n\t\t\t\t%s\n\t\t\t</li>\n", $1;
	}
	printf "\t\t</ol>\n\t</div>\n</d:entry>\n";
}
