package log::code;

use Dancer ':syntax';
use log::db;

prefix '/code';

get '/' => sub {
    my $entry = "code";
	my $table = "main";
	my $field = _entry($table,$entry);
	my $list_table = "code"; 
	my $list = _list($list_table);
	template 'list' => {
	   'text' => $field->{text}, 
	   'title' => $field->{title}, 
	   'root'  => $entry,
	   'list' => $list,
	}, { layout => 'code' };
};

get '/category' => sub {
	my $entry = "category";
	my $table = "code";
	my $field = _entry($table,$entry);
	my $list_table = "category"; 
	my $list = _list($list_table);
	my $root = "$table/$entry";
	template 'list' => {
	   'text' => $field->{text}, 
	   'title' => $field->{title}, 
	   'root' => $root,
	   'list' =>  $list,
	}, { layout => 'code' };
};

get '/category/:report' => sub {
	my $entry = params->{report};
	my $table = "category";
	my $field = _entry($table,$entry);
	template 'entries' => {
	   'text' => $field->{text}, 
	   'title' => $field->{title}, 
	}, { layout => 'code' };
};

get '/category2' => sub {
	my $entry = "category2";
	my $table = "code";
	my $field = _entry($table,$entry);
	my $list_table = "category2"; 
	my $list = _list($list_table);
	my $root = "$table/$entry";
	template 'list' => {
	   'text' => $field->{text}, 
	   'title' => $field->{title}, 
	   'root' => $root,
	   'list' =>  $list,
	}, { layout => 'code' };
};

get '/category2/:entry' => sub {
	my $entry = params->{entry};
	my $table = "category2";
	my $field = _entry($table,$entry);
	template 'entries' => {
	   'text' => $field->{text}, 
	   'title' => $field->{title}, 
	}, { layout => 'code' };
};

get '/:entr' => sub {
    	my $entry = params->{entr};
	my $table = "code";
	my $field = _entry($table,$entry);
	template 'entries' => {
	   'text' => $field->{text}, 
	   'title' => $field->{title}, 
	}, { layout => 'code' };
};


1;
