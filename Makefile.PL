use inc::Module::Install;
name 'Jenkins-NotificationListener';
all_from 'lib/Jenkins/NotificationListener.pm';

requires 'Net::Jenkins';
requires 'Moose';
requires 'methods';
requires 'JSON::XS';
requires 'AnyEvent::Socket';
requires 'Try::Tiny';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';

# auto_set_repository;
auto_include;
WriteAll;
