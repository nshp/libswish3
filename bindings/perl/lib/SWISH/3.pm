package SWISH::3;

use 5.008_003;
use strict;
use warnings;

our $VERSION = '0.01';

$ENV{SWISH3} = 1; # should be set by libswish3 in swish.c but doesn't seem to.

use Carp;
use Data::Dump;
use Devel::Peek;

require XSLoader;
XSLoader::load( __PACKAGE__, $VERSION );

sub new {
    my $class = shift;
    my %arg   = @_;
    my $self  = $class->init;

    if ( $arg{config} ) {
        $self->get_config->add( $arg{config} );
    }

    #defaults
    for my $param (qw( data_class parser_class config_class analyzer_class ))
    {
        my $method = 'set_' . $param;

        #warn "$method";
        $self->$method( $arg{$param} ) if exists $arg{param};
    }

    if ( !$arg{handler} ) {
        no strict 'refs';
        no warnings 'redefine';
        my $data_class = $self->get_data_class;
        eval "use $data_class";
        if ($@) {
            croak "can't load data_class $data_class:\n$@";
        }
        $arg{handler} = \&{ $data_class . '::handler' };
    }

    $self->set_handler( $arg{handler} );

    # KS default regex -- should also match swish_tokenize() behaviour
    $arg{regex} ||= qr/\w+(?:'\w+)*/;
    $self->set_regex( $arg{regex} );

    return $self;
}

sub parse {
    my $self = shift;
    my $what = shift
        or croak "parse requires filehandle, scalar ref or file path";
    if ( ref $what eq 'SCALAR' ) {
        return $self->parse_buffer($what);
    }
    elsif ( ref $what ) {
        return $self->parse_fh($what);
    }
    else {
        return $self->parse_file($what);
    }
}

sub dump {
    my $self = shift;
    if (@_) {
        Dump(@_);
        Data::Dump::dump(@_);
    }
    else {
        Dump($self);
        Data::Dump::dump($self);
    }
}

1;
__END__

=head1 NAME

SWISH::3 - Perl interface to libswish3

=head1 SYNOPSIS

 use SWISH::3;
 my $swish3 = SWISH::3->new(
                config      => 'path/to/config.xml',
                handler     => \&my_handler,
                tokenizer   => qr/\w+(?:'\w+)*/,
                );
 $swish3->parse( 'path/to/file.xml' )
    or die "failed to parse file: " . $swish3->error;
 
 printf "libxml2 version %s\n", $swish3->xml2_version;
 printf "libswish3 version %s\n", $swish3->version;
 
 
=head1 DESCRIPTION

SWISH::3 is a Perl interface to the libswish3 C library.


=head1 METHODS

=head2 xml2_version

Returns the libxml2 version used by libswish3.

=head2 version

Returns the libswish3 version.


=head1 SEE ALSO

L<http://swish-e.org/>

SWISH::Prog

=cut
