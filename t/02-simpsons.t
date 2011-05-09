use strict;
use Test::More tests => 12;
BEGIN { use_ok('Data::Object') };


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
ok($homer->isa("Data::Object::Base"),"Homer isa Data::Object::Base"); #Test 2
ok($homer->isa("Data::Object::Hash"),"Homer isa Data::Object::Hash"); #Test 3
ok($homer->type eq "HASH","Homer is a hash type underneath"); #Test 4
ok(!$homer->blessed,"Homer is not blessed"); #Test 5
ok((ref $homer->raw) eq "HASH","Homer Object Raw is a HASH Refrence"); #Test 6

is($homer->wife->name,"Marge Simpson","Homer's wife is Marge Simpson"); #Test 7
is($homer->children->count,3,"Homer has 3 kids"); #Test 8

ok($homer->wife->children($homer->children),"Homer's Kids are Marges Kids"); #Test 9

  #Base Data Structure is left in tact, and modified as one would think.
is($homer->wife->children->count,3,"Marge has 3 kids also"); #Test 10

  #Traverse easily through an array of hashes
is($homer->children->first( sub { $_->name eq "Lisa Simpson" } )->age,8,"Lisa is 8 years old"); #Test 11

  #Get Homers Daughters
  my @homers_girls = $homer->children->grep( sub { $_->gender eq "Female" } );
ok(scalar @homers_girls == 2,"Homer has two Daughters"); #Test 12
