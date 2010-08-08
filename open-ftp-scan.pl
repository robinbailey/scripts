#!/usr/bin/perl
use Net::FTP;
use threads;
use Thread::Queue;

#Usage = open-ftp-scan.pl xxx.xxx.xxx
#This scans a /24 network

$queue = new Thread::Queue;
$i = 1;
while ($i < 256)
{
	$queue->enqueue("$i");
	$i++
}
$| = 1;
$host = $ARGV[0];
$host .= ".";
system("cls");


while (!$end)
{
	$thr1 = threads->new(\&connect);
	$thr2 = threads->new(\&connect);
	$thr3 = threads->new(\&connect);
	$thr4 = threads->new(\&connect);
	$thr5 = threads->new(\&connect);
	$data1 = $thr1->join;
	$data2 = $thr2->join;
	$data3 = $thr3->join;
	$data4 = $thr4->join;
	$data5 = $thr5->join;
	print $data1;
	print $data2;
	print $data3;
	print $data4;
	print $data5;
}
print "\n\n@working";



sub connect
{
	$final = $queue->dequeue_nb;
	if (!$final)
	{
		print "\n\n@working";
		$end = 1;
		exit;
	}
	$target = ($host . $final);
	$ftp = Net::FTP->new("$target", Debug => 0, Timeout => 2);
	if ($ftp)
	{
		$ftp->login("anonymous",'anonymous@example.com');
		if ($ftp)
		{
			$ftp->pwd() or return "$target - Can't Login\n";
			push (@working, $target);
			return "$target\t\t\t\a\n";
		}
	}
}
sleep 3;
