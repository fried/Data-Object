package Data::Object::Array;
use Moose;
use namespace::autoclean;

extends 'Data::Object::Base';

use strict;
use warnings;

=head1 NAME

Data::Object::Array - Perl module for providing OO methods to perl arrays.

=head1 DESCRIPTION

This module makes use of L<Moose::Meta::Attribute::Native::Trait::Array> to gain OO array methods
without re-inventing the wheel.

Each method from L<Moose::Meta::Attribute::Native::Trait::Array> is availible.

=head1 ATTRIBUTES

=over 4

=item raw

Overload raw so we can have some native array methods

=cut

has '+raw' => (
	        traits => ['Array'],
		handles => {
		    count => 'count',
		    is_empty => 'is_empty',
		    _elements => 'elements',
		    _pop => 'pop',
		    _reduce => 'reduce',
		    _push => 'push',
		    _shift => 'shift',
		    _unshift => 'unshift',
		    _splice => 'splice',
		    _sort => 'sort',
		    _sort_in_place => 'sort_in_place',
		    _shuffle => 'shuffle',
		    _uniq => 'uniq',
		    join => 'join',
		    _delete => 'delete',
		    _insert => 'insert',
		    clear => 'clear',
		    _natatime => 'natatime',
		}
            );

=back

=head1 METHODS

=over 4

=item _get

Retrieve a value from the raw

=cut

sub _get {
    my ($self,$index) = @_;
    return $self->raw->[$index];
}


=item _set

Set replacement I want the original data strucuture modified

=cut

sub _set {
    my ($self,$index,$value) = @_;
    return $self->raw->[$index] = $value;
}

=item first

Replacement for first, so that $_ is a D:O object

=cut

sub first {
    my $self = shift;
    my $sub = shift;

    foreach ($self->elements) {
	if ( $sub->() ) {
	    return $_;
	}
    }
    return undef;
}

=item grep

Wrapper for core grep to make $_ be a D:O object

=cut

sub grep {
    my $self = shift;
    my $sub = shift;

    return grep { $sub->() } $self->elements;
}

=item map

Wrapper for core map to make $_ be a D:O object

=cut

sub map {
    my $self = shift;
    my $sub = shift;
    return map { $sub->() } $self->elements;
}

=item AUTOLOAD

AUTOLOAD Wrappers for all methods that could take in or return refs

If they return refs then we want them to be wrapped in D:O objects.

if they consume refs we want to make sure they are not D:O objects but the raws instead.

=cut

sub AUTOLOAD {
    my $self = shift;

    #Strip off the package name, it is not needed
    my ($item) = (our $AUTOLOAD =~ /([^:]+)$/);

    return if ($item eq 'DESTROY');

    #If Item is one of the methods that can return ref elements wrap the call to the backend
    if ($item =~ /^reduce|shift|pop|sort|sort_in_place|shuffle|uniq|elements|delete|natatime$/) {
	my $backend = "_$item";
	return $self->_ClassIfPossible( $self->$backend( @_ ) );
    }
    elsif ($item eq 'splice') { #Splice could take in refs and return refs
	return $self->_ClassIfPossible( $self->_splice( $self->_deClassArgs(@_) ) );
    }
    elsif ($item =~ /^insert|unshift|push$/) {
	my $backend = "_$item";
	return $self->$backend( $self->_deClassArgs( @_ ) );
    }

    #Otherwise lets pass this to the super class
    my $super = "SUPER::$item";
    $self->$super( @_ );
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
