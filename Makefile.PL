
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;

use File::ShareDir::Install;
install_share "share";


my %WriteMakefileArgs = (
  'ABSTRACT' => 'SOAP client for the SAP web services',
  'AUTHOR' => 'Brian Phillips <bphillips@digitalriver.com>',
  'BUILD_REQUIRES' => {
    'Module::Build' => '0.3601'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31',
    'File::ShareDir::Install' => '0.03',
    'Module::Build' => '0.3601'
  },
  'DISTNAME' => 'DR-SAP',
  'EXE_FILES' => [],
  'LICENSE' => 'restricted',
  'NAME' => 'DR::SAP',
  'PREREQ_PM' => {
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
  'VERSION' => '0.15',
  'test' => {
    'TESTS' => 't/*.t t/mock/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM}; 
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod}; 
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);

package
MY;
use File::ShareDir::Install qw(postamble);


