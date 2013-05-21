package log::db;

use strict;
use Dancer::Plugin; 
use Dancer::Plugin::Database;
use Time::Piece;

register _connect_db => sub {
  my $db = database();
  return $db;
};

register _entry => sub {
  my ($table, $url) = @_;
  my $db = _connect_db();
  my $sth = $db->quick_select($table, { url => $url})
  or die $db->errstr;
  return $sth;
};

register _list => sub {
  my $table = shift;
  my $db = _connect_db();
  my $sql = qq{select * from $table order by id desc};
  my $sth = $db->prepare($sql) or die $db->errstr;
  $sth->execute or die $sth->errstr;
  my $entries = $sth->fetchall_arrayref({});
  map { my $date = Time::Piece->strptime($_->{datetime},"%Y-%m-%d %H:%M:%S");
      $_->{datetime} = $date->strftime("%b %d %Y");
  } @$entries;
  return $entries;
};

register_plugin;

1;
