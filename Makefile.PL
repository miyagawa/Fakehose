use inc::Module::Install;
all_from 'lib/Fakehose.pm';
readme_from('lib/Fakehose.pm');
requires 'Tatsumaki';
requires 'Twiggy';
build_requires 'Test::More', 0.88;
test_requires 'Test::Requires';
auto_set_repository();
WriteAll;
