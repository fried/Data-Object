package Data::Object::Base;
use Moose;
use namespace::autoclean;

use strict;
use warnings;

use Scalar::Util ();
use Data::Dumper ();

=head1 NAME

Data::Object::Base - Perl base class for OO methods to perl data structures.

=head1 DESCRIPTION

This module is a base class for common methods used by Data::Object sub classes

=head1 ATTRIBUTES

=over 4

=item raw

    This is the raw refrence, Use when needed to get the original data structure

=cut

    has 'raw' => ( is => 'ro', isa => 'Ref', required => 1 );

=item type

    This will return the reftype of the wrapped structure

=cut

    has 'type' => ( is => 'ro', isa => 'Maybe[Str]', default => sub { Scalar::Util::reftype ( $_[0]->raw ) }, lazy => 1 );

=item blessed

    This will return a true value if the wrapped structure is a blessed object.
    The return value will be the blessed value, or undef if its not blessed.

=cut

    has 'blessed' => ( is => 'ro', isa => 'Maybe[Str]', default => sub { blessed ( $_[0]->raw ) }, lazy => 1 );
    has 'children' => ( is => 'ro', isa => 'HashRef', default => sub { {} }, reader => '_children', clearer => 'cleanup'); #Default Empty

=back

=head1 METHODS

=over 4

=item cleanup

Empty the children cache, this is probly not needed.
Unless you want to serialize/freeze a C:D:E object. Because the children cache makes use of ref addresses
which will not make any sense after deserialization/thaw, and just take up memory

=item get ( KEY | INDEX )

get an item from the backend

This is a wrapper to make sure get items are wrapped in a D:O object

=cut
sub get {
    my $self = shift;

    return $self->_ClassIfPossible( $self->_get(@_) );
}

=item set

set a value in a data structure, makeing sure they are not D:O objects

=cut

sub set {
    my $self = shift;

    #Make sure we dont put in D:O objects in our data structure. Unless we realy want to

    return $self->_set( $self->_deClassArgs(@_) );
}

=item dump

Dump the data structure in side this wrapper and return it.

=cut

sub dump {
    my $self = shift;
    local $Data::Dumper::Terse = 1;
    return Data::Dumper::Dumper($self->raw),"\n";
}

=item _ClassIfPossible

Most of the array methods return arrays of elements,
if those elements are refrences I want them turned into D:O Objects

Store a cache of D:O objects created by this instance by the ref value.

=cut
sub _ClassIfPossible {
    my $self = shift;
    for (0..$#_) { #Check every element in the @_
	if (ref $_[$_]) { #Its a refrence JUMP ON IT
	    #Get the address string, protect against stringification
	    my $refaddr = Scalar::Util::refaddr $_[$_];
	    my $reftype = Scalar::Util::reftype $_[$_];
	    #See if we have an existing class for this ref
	    if ( blessed $self->_children->{ $refaddr } ) {
		my $instance = $self->_children->{ $refaddr };

		#Sanity Check, make sure the object represents our ref
		if ($instance->raw == $_[$_]) {
		    $_[$_] = $instance; #Return out existing instance
		    next; #We are done with this argument
		}
	    }
	    #Wrap a D:O object around the ref object, and stick it in our cache
	    my $instance = Data::Object->wrap( $_[$_] );
	    $self->_children->{ $refaddr } = $instance;

	    #Replace the ref in the args with the new D:O object.
	    $_[$_] = $instance;
	}
    }
    return wantarray ? @_ : $_[0];
}

=item _deClassArgs

This private method is used to change out D:O objects with their raw references.

=cut

sub _deClassArgs {
    my $self = shift;
    for (0..$#_) { #Check to see if one of the items is a D:O object if so use the ->raw instead
	if (blessed $_[$_] && $_[$_]->isa("Data::Object::Base") ) {
	    $_[$_] = $_[$_]->raw;
	}
    }
    return wantarray ? @_ : $_[0];
}

=item AUTOLOAD

AUTOLOAD accessor methods for every key/index in the raw class

=cut

sub AUTOLOAD {
    my $self = shift;

    #Strip off the package name, it is not needed
    my ($item) = (our $AUTOLOAD =~ /([^:]+)$/);
    return if ($item eq 'DESTROY');

    #If arguments assume set
    if (scalar @_) {
	$self->set($item,@_);
    }

    #Otherwise its a get request
    return $self->get($item);
}


=back

=head1 AUTHOR

Jason Fried <fried@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Jason Fried. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
__END__
