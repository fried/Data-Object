package Data::Object;
use Moose;
use namespace::autoclean;

use strict;
use warnings;

our $VERSION = '0.002';

use Carp;
use Scalar::Util ();

use Data::Object::Base;

=head1 NAME

Data::Object - Perl module for providing OO methods to perl data structures.

=head1 SYNOPSIS

  use Data::Object;

  #Simpsons Data Refrence
  my $ref = {
		name => "Homer Simpson",
		children => [
				{
				    name => "Bart Simpson",
				    age => 10,
				    gender => "Male"
				},
				{
				    name => "Lisa Simpson",
				    age => 8,
				    gender => "Female"
				},
				{
				    name => "Maggie Simpson",
				    age => 1, #Dont Bark at me its not realy given.
				    gender => "Female"
				}
			    ],
		age => 38,
		job => "Safety Inspector",
		gender => "Male",
		wife => {
			    name => "Marge Simpson",
			    age => 36,
			    job => "Housewife",
			    gender => "Female"
			}
	    };

  #Wrap the given refrence and return a class for working with the data.
  my $homer = Data::Object->wrap($ref);

  print $homer->wife->name;   		# "Marge Simpson"
  print $homer->children->count; 	# 3

  my $marge = $home->wife;
  $marge->children($homer->children);    # Homers kids are now Marges kids
  $marge->set("children",$home->get("children"));  #SAME
  #Base Data Structure is left in tact, and modified as one would think.
  print $homer->wife->children->count; 	# 3

  #Traverse easily through an array of hashes
  print $homer->children->first( sub { $_->name eq "Lisa Simpson" } )->age;    # 8

  #Get Homers Daughters
  my @homers_girls = $homer->children->grep( sub { $_->gender eq "Female" } );
  foreach (@homers_girls) {
      print "Name: ",$_->name," Age: ",$_->age,"\n";
  }


=head1 DESCRIPTION

This module attempts to provide class style accessors for perl data structures.
In an attempt to make it easier to traverse said data structures in an OO way.

Currently only Array and Hash structures are handled in any way, all others are returned as is.

See: L<Data::Object::Base>, L<Data::Object::Hash>, L<Data::Object::Array>

=head1 METHODS

=over 4

=item wrap

Wrap a data structure so that accessing it is possible via OO style methods.

=cut

sub wrap {
    my $class = shift;

    my $type = ref $_[0];
    if ( scalar @_ == 1 && $type ) {
	if ( $type eq "HASH" ) {
	    my $class = "Data::Object::Hash";
	    Class::MOP::load_class($class);
	    return $class->new(raw => $_[0]);
	}
	elsif ( $type eq "ARRAY" ) {
	    my $class = "Data::Object::Array";
	    Class::MOP::load_class($class);
	    return $class->new(raw => $_[0]);
	}
	return wantarray ? @_ : $_[0]; #If neither just return what was sent
    }
    else {
	croak "This method only handles a single argument which must be a ref to a data structure\n";
    }
}

=back

=head1 TODO

Need to clean up the documentation, need to modify any existing methods
that takes an annonymous sub and make it use D:O blessed objects.

Need more data manipulation methods.
Like Sort for hash tables, sort_by_key(key) etc.

Overload cmp and <=> so that Data::Object instances can be compaired to each other. (by raw ref id)

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
