package log::db;

use Dancer::Plugin;
use Dancer::Plugin::Database;

register _connect_db => sub {
    my $db = database();
    return $db;
};

register _entry => sub {
    my ( $table, $url ) = @_;
    my $db = _connect_db();
    my $sth = $db->quick_select( $table, { url => $url } )
      or die $db->errstr;
    return $sth;
};

register_plugin;

1;
