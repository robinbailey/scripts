#!/usr/bin/perl
use LWP::Simple;

#Usage : folderscan.pl <hostname>
unlink("folders-found.txt");
$host = $ARGV[0];
$hostname = $host;

# Number of characters different pages can be while being classified as the same
# If you're getting false postives, raise this to above the diff printed
$maxdiff = 50;


open(FILE, "folder-list.txt") or die("Can not open file.\n"); 
@lines = <FILE>; 
close(FILE); 

# Scan any folders in the robots.txt file on the site
$robots = get("http://".$host."/robots.txt");
@robots = split(/\n/, $robots);
foreach $robot (@robots)
{
	if (($robot =~ m/Disallow: \/([a-zA-Z0-9\/\?\.\-_]+)/) || ($robot =~ m/Allow: \/([a-zA-Z0-9\/\?\.\-_]+)/))
	{
		$line = $1;
		$line =~ s/\?$//;
		$line =~ s/\/$//;
		if (($line) && ($line !=~ /^\?$/) && ($line !=~ /^\/$/))
		{
			unshift (@lines, $line);
		}
	}
}

system("clear");
&folderscan;

# First scan has taken place
# Any that were found are stored in @working
foreach (@working)
{
	$recursive = $_;
	$host = $hostname;
	$x++;
	&folderscan;
}
print "\n$x folders found\n";

#
# Main program logic
#

sub folderscan
{

	$content = getstore("http://".$host."/sadlfhw94evnetyvoesnmvtoescmn47vob", "/dev/null");
	if ($content != 404)
	{
		print "Site didn't return 404\nFalling back to length based page matching\nIf you get too many false positives, raise \$maxlength to above the diff printed for the false positives";
		$content = get("http://".$host."/sadlfhw94evnetyvoesnmvtoescmn47vob");
		$len = length($content);
	}
	if ($len)	# Site didn't return a 404, so we have to check by page length
	{
		foreach (@lines)
		{
			$folder = $_;
			chomp ($folder);
			$content = get("http://".$host.$recursive."/".$folder);
			$newlen = length($content);
			$diff = abs(($len - $newlen));
			if ($diff <= $maxdiff)
			{
				next;
			}
			else
			{
				$content = $host.$recursive."/".$folder;
				$folder = "/$folder";
				print "$content";
			 	print "\t\t\t\t\t$diff\n";
				push(@working, $recursive.$folder);
				$num++;
				open(FILE, ">>folders-found.txt"); 
				print FILE "$content\n"; 
				close(FILE);
				
			}
		}
	}
	else
	{
		foreach (@lines)
		{
			$folder = $_;
			chomp ($folder);
			$content = getstore("http://".$host.$recursive."/".$folder, NUL);
			if ($content == 404)
			{
				next;
			}
			elsif ($content == 200)
			{
				$content = $host.$recursive."/".$folder;
				$folder = "/$folder";
				print "$content\n";
				push(@working, $recursive.$folder);
				$num++;
				open(FILE, ">>folders-found.txt"); 
				print FILE "$content\n"; 
				close(FILE);
				
			}
			else
			{
				$content .= " ".$recursive."/".$folder."\n";
				print $content;
			}
		}
	}

}
