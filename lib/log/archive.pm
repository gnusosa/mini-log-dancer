package log::archive;

use Dancer ':syntax';
use log::db; 

prefix '/archive';

get '/' => sub {
  my $table = "entries";
  my $list = _list($table);
  template 'archive', { list => $list },
   { layout => 'archive' };
};

1;


