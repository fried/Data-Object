BEGIN { require 5.8.3; }
use inc::Module::Install 0.87;

name('Class-Data-Easy');
abstract_from 'lib/Class/Data/Easy.pm';
author 'Jason Fried <fried@cpan.org>';
version '0.001';
license 'perl';
requires 'Moose' => '0.90';
test_requires 'Test::More' => '0.47';
repository 'http://github.com/fried/Class-Data-Easy';
WriteAll;
