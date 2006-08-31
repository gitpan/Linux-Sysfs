#!perl

use strict;
use warnings;
use Test::More tests => 14;
use Test::Exception;
use Linux::Sysfs;

require 't/common.pl';

my $inval_path          = '/sys/invalid/path';
my $val_file_path       = '/sys/block/sda/dev';
my $val_write_attr_path = '/sys/class/net/eth0/tx_queue_len';

# close 
{
    my $attr = Linux::Sysfs::Attribute->open($val_file_path);
    isa_ok( $attr, 'Linux::Sysfs::Attribute' );

    lives_ok(sub {
            $attr->close;
    }, 'close');

}

{
    my $attr = bless \(my $s), 'Linux::Sysfs::Attribute';
    lives_ok(sub {
            $attr->close;
    }, 'close invalid pointer');
}


# open
{
    my $attr = Linux::Sysfs::Attribute->open($val_file_path);
    isa_ok( $attr, 'Linux::Sysfs::Attribute' );

    diag(sprintf "Attrib name = %s, at %s", $attr->name, $attr->path);

    $attr->close;
}

{
    my $attr = Linux::Sysfs::Attribute->open($inval_path);
    ok( !defined $attr, 'open on invalid path' );
}

{
    no warnings 'uninitialized';
    my $attr = Linux::Sysfs::Attribute->open(undef);
    ok( !defined $attr, 'open on undefined value' );
}


# read
{
    my $attr = Linux::Sysfs::Attribute->open($val_file_path);
    isa_ok( $attr, 'Linux::Sysfs::Attribute' );

    ok( $attr->read, 'read' );
    show_attribute($attr);

    $attr->close;
}

{
    my $attr = bless \(my $s), 'Linux::Sysfs::Attribute';
    ok( !$attr->read, 'read on invalid attr' );
}


# write
{
    my $attr = Linux::Sysfs::Attribute->open($val_write_attr_path);
    isa_ok( $attr, 'Linux::Sysfs::Attribute' );
    ok( $attr->read, 'read' );

    my $old_value = $attr->value;

    my $ret = $attr->write($old_value);
    ok( $ret, 'write' );

    diag(sprintf 'Attribute at %s now has value %s', $attr->path, $attr->value)
        if $ret;

    $ret = $attr->write('this should not get copied in the attrib');
    ok( !$ret, 'write invalid data' );

    $attr->close;


    my $fake_attr = bless \(my $s), 'Linux::Sysfs::Attribute';

    $ret = $fake_attr->write($old_value);
    ok( !$ret, 'write on invalid attr' );
}
