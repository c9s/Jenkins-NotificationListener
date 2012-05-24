use inc::Module::Install;
name 'Jenkins-NotificationListener';
all_from 'lib/Jenkins/NotificationListener.pm';

requires 'Net::Jenkins' => 0.03;
requires 'Moose';
requires 'methods';
requires 'JSON::XS';
requires 'AnyEvent::Socket';
requires 'Try::Tiny';

tests 't/*.t';
author_tests 'xt';

install_script 'scripts/jenkins-notification-listener.pl';

test_requires 'Test::More';

# auto_set_repository;
auto_include;
WriteAll;
