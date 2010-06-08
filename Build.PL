
use strict;
use warnings;

use Module::Build 0.3601;

my %module_build_args = (
  'build_requires' => {
    'Module::Build' => '0.3601'
  },
  'configure_requires' => {
    'ExtUtils::MakeMaker' => '6.31',
    'File::ShareDir::Install' => '0.03',
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'SOAP client for the SAP web services',
  'dist_author' => [
    'Brian Phillips <bphillips@digitalriver.com>'
  ],
  'dist_name' => 'DR-SAP',
  'dist_version' => '0.15',
  'license' => 'restricted',
  'module_name' => 'DR::SAP',
  'recommends' => {},
  'requires' => {
    'File::ShareDir' => '0',
    'Module::Pluggable' => '0',
    'Moose' => '0',
    'MooseX::Role::Parameterized' => '0',
    'MooseX::Types' => '0',
    'URI' => '0',
    'XML::Compile' => '0',
    'XML::Compile::SOAP' => '0',
    'namespace::autoclean' => '0'
  },
  'script_files' => [],
  'share_dir' => 'share'
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
