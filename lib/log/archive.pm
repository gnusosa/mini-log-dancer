package log::archive;

use Dancer ':syntax';
use log::db; 
use Time::Piece;


sub _archive_sql {
	my $db = _connect_db();
	my $sql = 'select datetime, url, title from entries order by id desc';
	my $sth = $db->prepare($sql) or die $db->errstr;
	$sth->execute or die $sth->errstr;
	my $entries = $sth->fetchall_arrayref({});
	map { my $date = Time::Piece->strptime($_->{datetime},"%Y-%m-%d %H:%M:%S"); 
		  $_->{datetime} = $date->strftime("%b %d %Y"); 
	} @$entries;
	return $entries;
}

prefix '/archive';

get '/' => sub {
	my $list = _archive_sql();
	template 'archive', { list => $list },
 	{ layout => 'archive' };
};

1;


