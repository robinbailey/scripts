#!/usr/bin/perl 
use Net::DNS;
use Getopt::Std;

$res = Net::DNS::Resolver->new;
$domain = $ARGV[-1];
$tempfile = "/tmp/dnsscan.txt";
unlink $tempfile;

sub usage
{
	if (!($ARGV[-1] =~ m/[a-zA-Z0-9\.\-]+\.[a-zA-Z]+/))
	{
		print "Usage : ./dnsscan.pl <options> <domain>\n\nOptions :\n\n-n : perform nmap scan\n-a : pass -A to nmap\n-o <file> : output nmap results to a file\n";
		exit;
	}
}

sub options
{
	getopts('ano:');
	if ($opt_n)
	{
		$nmapenabled = '1';
	}
	if ($opt_a)
	{
		$nmapopt .= '-A ';
	}
	if ($opt_o)
	{
		$nmapopt .= '-oN '.$opt_o.' ';
	}
}

sub wildcard
{
	$query = $res->search('ksjdahflkafhdkjsd.'.$domain);
	if ($query)
	{
		foreach $rr ($query->answer)
		{
			next unless $rr->type eq "A";
			print $rr->address,  " - *.$domain\n";
			$wildcard = $rr->address;
			push (@found, $rr->address);
		}
	}
}

@subdomains = ("a","access","accounting","accounts","admin","administrator","alpha","apollo","ayuda","backup","backups","beta","billing","blackboard","blog","blogs","bsd","bt","c","ca","cart","cas","catalog","catalogo","catalogue","chat","chimera","chronos","ci","citrix","classroom","clientes","clients","co","connect","controller","correoweb","cp","cpanel","customers","d","da","data","db","dbs","dc","demo","demon","demostration","descargas","developers","development","diana","directory","dmz","domain","domaincontroller","domain-controller","download","downloads","e","eaccess","email","en","events","ex","example","examples","exchange","extranet","f","files","finance","firewall","foro","foros","forum","forums","freebsd","ftpd","g","galeria","gallery","gateway","gilford","groups","groupwise","gu","guest","guia","guide","help","helpdesk","hera","heracles","hercules","home","homer","hotspot","hypernova","i","im","images","imail","imap","imap3","imap3d","imapd","imaps","imgs","imogen","in","inmuebles","internal","interno","intranet","io","ip","ip6","ipsec","ipv6","irc","ircd","is","isa","it","j","ja","jabber","jupiter","k","l","la","lab","laboratories","laboratorio","laboratory","labs","library","linux","lisa","log","logs","login","logon","logs","m","mail","mailgate","manager","marketing","media","member","members","mercury","meta","meta01","meta02","meta03","meta1","meta2","meta3","miembros","minerva","mob","mobile","moodle","movil","mssql","mx","mx0","mx01","mx02","mx03","mx1","mx2","mx3","my","mysql","n","nelson","neon","net","netmail","news","novell","ns","ns0","ns01","ns02","ns03","ns1","ns2","ns3","nt","ntp","o","office","on","online","op","ops","operation","operations","ora","oracle","os","osx","ou","owa","ox","p","partners","pcanywhere","pegasus","pendrell","personal","photo","photos","pop","pop3","portal","postgresql","postman","postmaster","pp","ppp","preprod","pre-prod","pre-production","private","pro","prod","production","proxy","prueba","pruebas","pub","public","q","r","ra","ras","remote","reports","research","restricted","robinhood","router","s","sa","sales","sample","samples","sandbox","search","secure","server","services","sharepoint","shop","shopping","sms","smtp","solaris","soporte","sp","sql","squirrel","squirrelmail","ssh","staff","staging","stats","sun","support","t","test","testing","tftp","tunnel","u","unix","upload","uploads","v","ventas","virtual","vista","vm","vms","vmware","vnc","vpn","vpn1","vpn2","vpn3","w","wap","web","web0","web01","web02","web03","web1","web2","web3","webadmin","webct","weblog","webmail","webmaster","webmin","win","win32","windows","ww0","ww01","ww02","ww03","ww1","ww2","ww3","www","www0","www01","www02","www03","www1","www2","www3","x","zeus");


sub mainscan
{
	foreach $sub (@subdomains)
	{
		chomp($sub);
		$query = $res->search($sub.'.'.$domain);
		if ($query)
		{
			foreach $rr ($query->answer)
			{
				next unless $rr->type eq "A";
				$add = $rr->address;
				if ($add != $wildcard)
				{
					print $rr->address,  " - $sub.$domain\n";
					push (@found, $rr->address);
				}
			}
		}
	}
}


sub nmapscan
{
	%hash = map { $_ => 1 } @found;
	@found = sort keys %hash;

	unlink $tempfile;
	open (output, ">$tempfile") || print "Could not open $tempfile $!";
	print output join("\n", @found);
	print output ("\n");
	close (output);

	print "\nStarting nmap scan\n\nOptions are : $nmapopt\n\n";

	$nmapresults = `nmap $nmapopt -iL $tempfile -PN`;
	print $nmapresults;
	unlink $tempfile;
}

&usage;
&options;
&wildcard;
&mainscan;
if ($nmapenabled)
{
	&nmapscan;
}
