package log::code;

use Dancer ':syntax';
use log::db;

prefix '/code';

get '/' => sub {
    my $entry = "code";
	my $table = "main";
	my $field = _entry($table,$entry);
	template 'entries' => {
	   'title' => $field->{title}, 
	   'text' => $field->{text}, 
	};
};

1;
