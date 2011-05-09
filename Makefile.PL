BEGIN { require 5.8.3; }
use inc::Module::Install 0.87;

name('Data-Object');
abstract_from 'lib/Data/Object.pm';
author 'Jason Fried <fried@cpan.org>';
version_from 'lib/Data/Object.pm';
license 'perl';
requires 'Moose' => '0.90';
test_requires 'Test::More' => '0.47';
repository 'http://github.com/fried/Data-Object';
WriteAll;
