package Class::Data::Easy;
use Moose;

=head1 NAME

Class::Data::Easy - Perl module for providing OO methods to perl data structures.

=head1 SYNOPSIS

  use Class::Data::Easy;
  my $ref = some_method_that_returns_massive_data_structure();
  my $eref = Class::Data::Easy->new($ref);
  
=head1 DESCRIPTION

This module attempts to provide class style accessors for perl data structures.
In an attempt to make it easier to traverse said data structures in an OO way.

=head1 METHODS

=head1 AUTHOR

Jason Fried <fried@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Jason Fried. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
__END__
