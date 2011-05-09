package Data::Object::Hash;
use Moose;
use namespace::autoclean;

extends 'Data::Object::Base';

use strict;
use warnings;

=head1 NAME

Data::Object::Hash - Perl module for providing OO methods to perl hash tables.

=head1 DESCRIPTION

This module makes use of L<Moose::Meta::Attribute::Native::Trait::Hash> to gain OO style HASH operators
without having to re-invent the wheel.

Each method from L<Moose::Meta::Attribute::Native::Trait::Hash> is availible.

=head1 ATTRIBUTES

=over 4

=item raw

Overload raw so we can have some native hash methods

=cut

has '+raw' => (
	        traits => ['Hash'],
		handles => {
		    is_empty => 'is_empty',
		    _delete => 'delete',
		    _kv => 'kv',
		    keys => 'keys',
		    exists => 'exists',
		    defined => 'defined',
		    _values => 'values',
		    _elements => 'elements',
		    clear => 'clear',
		    count => 'count',
		}
            );

=back

=head1 METHODS

=over 4

=item _get KEY

    Retrieve the value of KEY from the raw

=cut

sub _get {
    my ($self,$key) = @_;
    return $self->raw->{$key};
}


=item _set KEY VALUE

    Rewrite of Set because the Moose Trait, creates new hash refrences.

=cut

sub _set {
    my ($self,$key,$value) = @_;

    return $self->raw->{$key} = $value;
}

=item AUTOLOAD

AUTOLOAD Wrappers for all methods that could return refs

If they return refs then we want them to be wrapped in D:O objects.

=cut

sub AUTOLOAD {
    my $self = shift;

    #Strip off the package name, it is not needed
    my ($item) = (our $AUTOLOAD =~ /([^:]+)$/);

    return if ($item eq 'DESTROY');

    #If Item is one of the methods that can return ref elements wrap the call to the backend
    if ($item =~ /^kv|values|elements|delete$/) {
	my $backend = "_$item";
	return $self->_ClassIfPossible( $self->$backend( @_ ) );
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
