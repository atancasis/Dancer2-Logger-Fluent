use strict;
use warnings;
no warnings 'redefine';

use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use Sys::Hostname;

plan tests => 2;

use Fluent::Logger;

sub Fluent::Logger::post {
    my ($self, $tag, $msg) = @_;
    subtest fluent => sub {
        plan tests             => 6;
        is $tag                => 'MyApp';
        is $msg->{level}       => 'info';
        is $msg->{message}     => 'debugging message';
        is $msg->{env}         => 'development';
        is $msg->{pid}         => $$;
        is $msg->{host}        => hostname();
    }
}

undef &Fluent::Logger::close;

{
    package MyApp;

    use Dancer2 0.151;
    use Dancer2::Logger::Fluent;

    set logger => 'fluent';

    undef &Dancer2::Logger::Fluent::DESTROY;

    get '/' => sub {
        info( "debugging message" );
        'foo';
    };
}

my $app = MyApp->to_app;
my $test = Plack::Test->create($app);
my $res = $test->request( GET '/' );
is( $res->code, 200, '[GET /] Request successful' );

done_testing;
