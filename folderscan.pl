#!/usr/bin/perl
use LWP::Simple;


#Usage : folderscan.pl <hostname>
unlink("folders-found.txt");
$host = $ARGV[0];
$hostname = $host;

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
		print "Error, site didn't return 404\n";
		exit;
	}
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
