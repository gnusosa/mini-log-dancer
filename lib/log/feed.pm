package log::feed;

use Dancer ':syntax';
use log::db;
use Dancer::Plugin::Feed;
use DateTime::Format::Strptime;

sub _feed_sql {
	my $db = _connect_db();
	my $sql = 'select * from entries order by id desc limit 10';
	my $sth = $db->prepare($sql) or die $db->errstr;
	$sth->execute or die $sth->errstr;
	my $entries = $sth->fetchall_arrayref({});
	return $entries;
}
sub _get_entries {
	my $item = _feed_sql();
	my $parser = DateTime::Format::Strptime->new(
										pattern => '%Y-%m-%d %H:%M:%S',
										locale => 'en_US',
										time_zone => 'US/Pacific',);
	[ map{           
		    my $dt = $parser->parse_datetime($_->{datetime});
			{ title => $_->{title} , link => config->{domain}.$_->{url},
			content => $_->{text}, author => config->{author},
			issued => $dt, 		
            }
		 } @$item
	]; 
}

prefix '/feed';

get '/' => sub {
    my $entry = "feed";
	my $table = "main";
	my $field = _entry($table,$entry);
	template 'entries' => {
	   'title' => $field->{title}, 
	   'text' => $field->{text}, 
	};
};

get '/:format' => sub {
	my $feed = create_feed(
		format  => params->{format},
		entries => _get_entries()
    );
    return $feed;
};

1;
