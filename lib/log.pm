package log;

use Dancer ':syntax';
use log::archive;
use log::code;
use log::db;
use log::feed;

our $VERSION = '0.1';
prefix undef;
# This is a mini-blog engine based on the notes and tips by
# the advent calendar for Dancer. 
# http://advent.perldancer.org/2010
# It lacks a comments section , and categories.
# It uses SQLite3 databases to handle and manage entries.
#
#
# Written by Carlos Ivan Sosa.
# http://log.gnusosa.net/
# gnusosa@gnusosa.net
#
# This log engine is free software, it is released under the
# same terms as Perl itself
sub _index_entry {
	my $db = _connect_db();
    my $sql = "select * from entries where id=(select max(id) from entries)";
	my $sth = $db->prepare($sql) or die $db->errstr;
	$sth->execute or die $sth->errstr;
	my $index_entry = $sth->fetchrow_hashref();
	return $index_entry;  
};

get '/' => sub {
	my $field = _index_entry();
	template 'index' => {
	   'url' => $field->{url}, 
	   'title' => $field->{title}, 
	   'text' => $field->{text}, 
	},{ layout => 'index' };
};

get '/faq' => sub {
    my $entry = "faq";
	my $table = "main";
	my $field = _entry($table, $entry);
	template 'entries' => {
	   'title' => $field->{title}, 
	   'text' => $field->{text}, 
	};
};

get '/info' => sub {
    my $entry = "info";
	my $table = "main";
	my $field = _entry($table,$entry);
	template 'entries' => {
	   'title' => $field->{title}, 
	   'text' => $field->{text}, 
	};
};

get '/:entr' => sub {
    my $entry = params->{entr};
	my $table = "entries";
	my $field = _entry($table,$entry);
	if (ref($field) eq "HASH"){
	template 'entries' => {
	   'title' => $field->{title}, 
	   'text' => $field->{text}, 
	};
	}
	else{ send_file '404.html';}	
};

true;
